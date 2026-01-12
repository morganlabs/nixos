import type { ModrinthModInfo, ModrinthModVersion } from "./APITypes";
import type { LockModRole, LockMod } from "../Lockfile";

export default class ModrinthAPI {
  private modInfoEndpoint = (id: string) =>
    `https://api.modrinth.com/v2/project/${id}`;
  private modVersionsEndpoint = (id: string) =>
    `https://api.modrinth.com/v2/project/${id}/version`;

  constructor(
    private gameVersion: string,
    private loader: string,
  ) {}

  /// Fetch a mod from the Modrinth API
  public async fetchMod(toml: Record<string, any>): Promise<{
    info: ModrinthModInfo;
    version: ModrinthModVersion;
    toml: Record<string, any>;
  }> {
    const { id, versionID } = toml;
    console.log(`Fetching mod ID ${id}`);

    // Get the endpoints for the mod information and all versions
    const modInfoEndpoint = this.modInfoEndpoint(id);
    let modVersionsEndpoint = this.modVersionsEndpoint(id);

    // If the toml specifies a specific version ID, specify it in the endpoint
    if (versionID) {
      modVersionsEndpoint += `/${toml.versionID}`;
    }

    try {
      // Concurrently fetch the mod info and version(s)
      const [infoRes, versionsRes] = await Promise.all([
        fetch(modInfoEndpoint),
        fetch(modVersionsEndpoint),
      ]);

      // Transform all responses to JSON
      const info = (await infoRes.json()) as ModrinthModInfo;

      // If a versionID is given, just return the version from the API
      if (versionID) {
        const version = (await versionsRes.json()) as ModrinthModVersion;
        return { info, version, toml };
      }

      const versions = (await versionsRes.json()) as ModrinthModVersion[];

      // Get the latest version from the array
      const version = this.getLatestVersion(versions, info.title);

      return { info, version, toml };
    } catch (e) {
      throw new Error(`Failed to fetch mod with ID ${id}: ${e}`);
    }
  }

  public getLatestVersion(json: ModrinthModVersion[], title: string) {
    const filteredForVersionAndLoader = json.filter(
      (j) =>
        j.game_versions.includes(this.gameVersion) &&
        j.loaders.includes(this.loader),
    );

    // Try to find only releases
    let filteredForVersionType = filteredForVersionAndLoader.filter(
      (j) => j.version_type === "release",
    );

    // Fallback to betas
    if (filteredForVersionType.length === 0)
      filteredForVersionType = filteredForVersionAndLoader.filter(
        (j) => j.version_type === "beta",
      );

    // Fallback to alphas
    if (filteredForVersionType.length === 0)
      filteredForVersionType = filteredForVersionAndLoader.filter(
        (j) => j.version_type === "alpha",
      );

    const latest = filteredForVersionType.reduce(
      (latest, item) =>
        !latest ||
        new Date(item.date_published) > new Date(latest.date_published)
          ? item
          : latest,
      undefined as (typeof filteredForVersionType)[number] | undefined,
    );

    if (!latest) throw new Error(`Failed to get latest version?`);

    if (latest.version_type !== "release")
      console.log(
        `[WARN] The only available version of mod "${title}" is "${latest.version_type}".`,
      );

    return latest;
  }

  public format(
    mod: { info: ModrinthModInfo; version: ModrinthModVersion },
    toml: Record<string, any>,
    role: LockModRole,
  ): LockMod {
    const { info, version } = mod;
    const primaryFile = version.files.find((a) => a.primary);
    const config = toml.config || [];

    if (!primaryFile) throw new Error("Failed to find primary mod file.");

    return {
      source: "modrinth",
      id: info.id,
      title: info.title,
      description: info.description,
      icon: info.icon_url,
      published: version.date_published,
      tags: toml.tags,
      role,
      file: primaryFile.url,
      sha: {
        type: "sha512",
        value: primaryFile.hashes.sha512,
      },
      config,
      dependencies: [
        ...version.dependencies
          .filter((d) => d.dependency_type === "required")
          .map((d) => d.project_id),
        ...(toml.dependencies || []),
      ],
    } as LockMod;
  }
}
