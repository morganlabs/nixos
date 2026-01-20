import { defineCollection } from "astro:content";
import { file } from "astro/loaders";
import { z } from "astro/zod";

const mods = defineCollection({
  loader: file("src/data/catalogue.json", {
    parser: (text) => JSON.parse(text).mods,
  }),
  schema: z.object({
    source: z.enum(["manual", "modrinth"]),
    id: z.string(),
    title: z.string(),
    description: z.string(),
    icon: z.string().optional().nullable(),
    published: z.string().optional(),
    tags: z.array(z.string()),
    role: z.enum([
      "server",
      "both-required",
      "both-optional",
      "client-required",
      "client-optional",
    ]),
    file: z.string(),
    sha: z.object({
      type: z.enum(["sha512", "sha256"]),
      value: z.string(),
    }),
    dependencies: z.array(z.string()),
  }),
});

const resourcePacks = defineCollection({
  loader: file("src/data/catalogue.json", {
    parser: (text) => JSON.parse(text).resourcePacks,
  }),
  schema: z.object({
    id: z.string(),
  }),
});

export const collections = { mods, resourcePacks };
