import { existsSync, readFileSync, writeFileSync } from "fs";

export class Lockfile {
  private path = "../catalogue.lock.json";
  private lockfile: LockfileObj = {
    mods: [],
    resourcePacks: [],
  };

  constructor() {
    if (existsSync(this.path)) {
      const lockfileString = readFileSync(this.path, "utf-8");
      this.lockfile = JSON.parse(lockfileString);
    }
  }

  get mods(): LockMod[] {
    return this.lockfile.mods;
  }

  get resourcePacks(): LockResourcePack[] {
    return this.lockfile.resourcePacks;
  }

  write() {
    writeFileSync(this.path, JSON.stringify(this.lockfile, null, 4));
  }

  hasMod(id: string): LockMod | undefined {
    return this.lockfile.mods.find((m) => m.id === id);
  }

  addMod(mod: LockMod) {
    this.lockfile.mods.push(mod);
  }

  print() {
    console.log(this.lockfile);
  }
}

interface LockResourcePack {}
interface LockfileObj {
  mods: LockMod[];
  resourcePacks: LockResourcePack[];
}

export type LockModRole =
  | "both-required"
  | "both-optional"
  | "client-required"
  | "client-optional"
  | "server";

interface ConfigFile {
  directory: string;
  filename: string;
  content: string;
}

export interface LockMod {
  source: "modrinth";
  id: string;
  title: string;
  description: string;
  icon?: string;
  published: string;
  tags: string[];
  role: LockModRole;
  file: string;
  sha512: string;
  dependencies?: string[];
  config?: ConfigFile[];
}
