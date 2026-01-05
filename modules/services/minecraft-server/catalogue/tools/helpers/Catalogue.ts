import toml from "toml";
import { existsSync, readFileSync } from "fs";

interface CatalogueObj {
  gameVersion: string;
  loader: string;

  mods: CatalogueMods;
}

export class Catalogue {
  private path = "../catalogue.toml";
  private catalogue: CatalogueObj = {
    gameVersion: "",
    loader: "",

    mods: {
      server: [],
      client: { required: [], optional: [] },
      both: { required: [], optional: [] },
    },
  };

  constructor() {
    if (!existsSync(this.path)) throw new Error("Catalogue does not exist!");

    const catalogueString = readFileSync(this.path, "utf-8");
    this.catalogue = toml.parse(catalogueString);
  }

  get gameVersion() {
    return this.catalogue.gameVersion;
  }

  get loader() {
    return this.catalogue.loader;
  }

  get mods(): CatalogueMods {
    return this.catalogue.mods;
  }

  print() {
    console.log(this.catalogue);
  }
}

export interface CatalogueModEntry {
  source: "modrinth";
  id: string;
  tags: string[];
}

interface CatalogueRequiredOrOptional {
  required: CatalogueModEntry[];
  optional: CatalogueModEntry[];
}

interface CatalogueMods {
  server: CatalogueModEntry[];
  client: CatalogueRequiredOrOptional;
  both: CatalogueRequiredOrOptional;
}
