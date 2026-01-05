import ModrinthAPI from "./helpers/ModrinthAPI";
import { Lockfile } from "./helpers/Lockfile";
import { Catalogue } from "./helpers/Catalogue";

import type { LockModRole } from "./helpers/Lockfile";
import type { CatalogueModEntry } from "./helpers/Catalogue";

const catalogue = new Catalogue();
const lockfile = new Lockfile();
const modrinth = new ModrinthAPI(catalogue.gameVersion, catalogue.loader);

const SAFELY_IGNORABLE_MOD_IDS: string[] = ["qvIfYCYJ"];

async function main() {
  const { server, both, client } = catalogue.mods;

  // Concurrently fetch all mods
  await Promise.all([
    fetchAllMods(server, "server", "mods"),
    fetchAllMods(both.required, "both-required", "mods"),
    fetchAllMods(both.optional, "both-optional", "mods"),
    fetchAllMods(client.required, "client-required", "mods"),
    fetchAllMods(client.optional, "client-optional", "mods"),
  ]);

  await fetchAllDependencies();

  try {
    lockfile.write();
  } catch (e) {
    console.error(`Error writing lockfile: ${e}`);
  }
}

/// Fetch all dependencies concurrently
async function fetchAllDependencies() {
  // Go through all mods in lockfile, get all listed dependencies, and filter
  // out any that should be explicitly ignored.
  const allDependencies = lockfile.mods
    .map((m) => m.dependencies)
    .flat()
    .filter((id) => !SAFELY_IGNORABLE_MOD_IDS.includes(id!));

  // Get all unique dependencies, and then format properly
  const uniqueDependencies = [...new Set(allDependencies)]
    .map(
      (id) =>
        ({
          id,
          source: "modrinth",
          tags: ["Support Mod"],
        }) as CatalogueModEntry,
    )
    .flat();

  // Remove all mods that are already in the lockfile
  const notInLockfile = uniqueDependencies.filter(
    (m) => !lockfile.hasMod(m.id),
  );
  if (notInLockfile.length === 0) return;

  // If there are non-installed dependencies, install them as required on the
  // client and server (required).
  await fetchAllMods(notInLockfile, "both-required", "dependencies");
  fetchAllDependencies();
}

/// Fetch all mods concurrently
async function fetchAllMods(
  mods: CatalogueModEntry[],
  role: LockModRole,
  type: "mods" | "dependencies",
) {
  console.log(`Fetching all ${role} ${type}`);

  const notInLockfile = mods.filter((m) => !lockfile.hasMod(m.id));
  const responses = await Promise.all(
    notInLockfile.map((m) => modrinth.fetchMod(m)),
  );

  for (const mod of responses) {
    const { info, version, toml } = mod;
    const formatted = modrinth.format({ version, info }, toml, role);
    lockfile.addMod(formatted);
  }
}

main().catch((e) => {
  console.error(e);
});
