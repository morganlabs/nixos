// MAIN API ENDPOINTS //

export interface ModrinthModVersion {
  game_versions: string[];
  loaders: string[];
  id: string;
  project_id: string;
  author_id: string;
  featured: boolean;
  name: string;
  version_number: string;
  changelog: string;
  changelog_url?: string;
  date_published: string;
  downloads: number;
  version_type: ModrinthVersionType;
  status: ModrinthVersionStatus;
  requested_status: ModrinthVersionRequestedStatus;
  files: ModrinthVersionFile[];
  dependencies: ModrinthDependency[];
}

export interface ModrinthModInfo {
  client_side: ModrinthSideSupport;
  server_side: ModrinthSideSupport;
  game_versions: string[];
  id: string;
  slug: string;
  project_type: ModrinthProjectType;
  team: string;
  organization: string;
  title: string;
  description: string;
  body: string;
  body_url?: string;
  published: string;
  updated: string;
  approved: string;
  queued?: string;
  status: ModrinthStatus;
  requested_status?: ModrinthRequestedStatus;
  moderator_message?: string;
  license: ModrinthLicense;
  download: number;
  followers: number;
  categories: string[];
  additional_categories: string[];
  loaders: string[];
  versions: string[];
  icon_url: string;
  issues_url: string;
  source_url: string;
  wiki_url?: string;
  discord_url?: string;
  donations_urls: ModrinthDonationURL[];
  gallery: ModrinthGalleryItem[];
  color: number;
  thread_id: string;
  monetization_status: ModrinthMonetizationStatus;
}

// SUB-TYPES AND INTERFACES //

type ModrinthSideSupport = "required" | "optional " | "unsupported" | "unknown";
type ModrinthProjectType = "mod" | "modpack" | "resourcepack" | "shader";
type ModrinthMonetizationStatus =
  | "monetized"
  | "demonetized"
  | "force-demonetized";
type ModrinthVersionType = "release" | "beta" | "alpha";
type ModrinthVersionStatus =
  | "listed"
  | "archived"
  | "draft"
  | "unlisted"
  | "scheduled";
type ModrinthVersionRequestedStatus =
  | "listed"
  | "archived"
  | "draft"
  | "unlisted";
type ModrinthVersionFileType =
  | "required-resource-pack"
  | "optional-resource-pack";
type ModrinthDependencyType =
  | "required"
  | "optional"
  | "incompatible"
  | "embedded";

type ModrinthRequestedStatus =
  | "approved"
  | "archived"
  | "unlisted"
  | "private"
  | "draft";

type ModrinthStatus =
  | "rejected"
  | "processing"
  | "withheld"
  | "scheduled"
  | "unknown"
  | ModrinthRequestedStatus;

interface ModrinthLicense {
  id: string;
  name: string;
  url?: string;
}

interface ModrinthDonationURL {
  id: string;
  platform: string;
  url: string;
}

interface ModrinthGalleryItem {
  url: string;
  raw_url: string;
  featured: boolean;
  title?: string;
  description?: string;
  created: string;
  ordering: number;
}

interface ModrinthVersionFileHashes {
  sha512: string;
  sha1: string;
}

interface ModrinthVersionFile {
  hashes: ModrinthVersionFileHashes;
  url: string;
  filename: string;
  primary: boolean;
  size: number;
  file_type?: ModrinthVersionFileType;
}

interface ModrinthDependency {
  version_id?: string;
  project_id: string;
  file_name?: string;
  dependency_type: ModrinthDependencyType;
}
