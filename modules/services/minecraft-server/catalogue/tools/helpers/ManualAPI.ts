import type { LockModRole, LockMod } from "./Lockfile";

export default class ManualAPI {
  constructor() {}

  public format(toml: Record<string, any>, role: LockModRole): LockMod {
    const config = toml.config || [];
    const filename = toml.file.split("/").pop();

    return {
      source: "manual",
      id: toml.id || filename,
      title: toml.title || filename,
      description:
        toml.description || "A manually managed mod with no description.",
      tags: toml.tags,
      role,
      file: toml.file,
      sha: {
        type: "sha256",
        value: toml.sha256,
      },
      config,
      dependencies: [],
    } as LockMod;
  }
}
