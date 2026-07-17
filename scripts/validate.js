#!/usr/bin/env node
"use strict";

/*
 * Verification gate for agent-toolkit.
 *
 * Dependency-free (Node stdlib only) so it runs anywhere, including CI. Checks that the repo
 * stays installable via `npx skills` and as a Claude Code plugin:
 *
 *   - .claude-plugin/plugin.json and marketplace.json are valid JSON with required keys
 *   - every skills/<name>/SKILL.md and agents/*.md has `name` + `description` frontmatter
 *   - every path referenced by plugin.json (skills dir, commands dir, agent files) exists
 *   - every commands/*.md (except README.md) has `name` + `description` frontmatter
 *   - if any hooks.json exists anywhere under hooks/, it is valid JSON
 *
 * Exit code 0 = all good, 1 = one or more problems.
 */

const fs = require("fs");
const path = require("path");

const ROOT = path.resolve(__dirname, "..");
const errors = [];
const err = (msg) => errors.push(msg);
const rel = (p) => path.relative(ROOT, p);

const isDir = (p) => { try { return fs.statSync(p).isDirectory(); } catch { return false; } };
const isFile = (p) => { try { return fs.statSync(p).isFile(); } catch { return false; } };
const read = (p) => fs.readFileSync(p, "utf8");

/** Return top-level keys of a Markdown YAML frontmatter block, or null if absent.
 *  Minimal parser (no YAML dependency) — sufficient for presence checks. */
function frontmatter(p) {
  const m = read(p).match(/^---\s*\n([\s\S]*?)\n---\s*(\n|$)/);
  if (!m) return null;
  const fm = {};
  for (const line of m[1].split("\n")) {
    const km = line.match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (km) fm[km[1]] = km[2].trim();
  }
  return fm;
}

function loadJson(p) {
  if (!fs.existsSync(p)) { err(`missing file: ${rel(p)}`); return null; }
  try {
    return JSON.parse(read(p));
  } catch (e) {
    err(`${rel(p)}: invalid JSON — ${e.message}`);
    return null;
  }
}

function checkPlugin() {
  const plugin = loadJson(path.join(ROOT, ".claude-plugin", "plugin.json"));
  if (!plugin) return;
  for (const key of ["name", "description"]) {
    if (!plugin[key]) err(`.claude-plugin/plugin.json: missing "${key}"`);
  }
  const skillsRel = plugin.skills || "./skills";
  if (!isDir(path.join(ROOT, skillsRel))) {
    err(`.claude-plugin/plugin.json: skills path not found: ${skillsRel}`);
  }
  if (typeof plugin.commands === "string") {
    if (!isDir(path.join(ROOT, plugin.commands))) {
      err(`.claude-plugin/plugin.json: commands path not found: ${plugin.commands}`);
    }
  }
  for (const agent of plugin.agents || []) {
    if (!isFile(path.join(ROOT, agent))) {
      err(`.claude-plugin/plugin.json: agent file not found: ${agent}`);
    }
  }
}

function checkMarketplace() {
  const mp = loadJson(path.join(ROOT, ".claude-plugin", "marketplace.json"));
  if (!mp) return;
  if (!mp.name) err('.claude-plugin/marketplace.json: missing "name"');
  const plugins = mp.plugins || [];
  if (plugins.length === 0) err(".claude-plugin/marketplace.json: no plugins listed");
  plugins.forEach((pl, i) => {
    if (!pl.name) err(`marketplace.json: plugin[${i}] missing name`);
    if (!("source" in pl)) err(`marketplace.json: plugin[${i}] missing source`);
  });
}

function checkFrontmatterFiles(files) {
  for (const p of files) {
    const fm = frontmatter(p);
    if (fm === null) { err(`${rel(p)}: missing or malformed YAML frontmatter`); continue; }
    for (const key of ["name", "description"]) {
      if (!fm[key]) err(`${rel(p)}: frontmatter missing "${key}"`);
    }
  }
}

function skillFiles() {
  const dir = path.join(ROOT, "skills");
  if (!isDir(dir)) return [];
  return fs.readdirSync(dir)
    .map((name) => path.join(dir, name, "SKILL.md"))
    .filter(isFile);
}

function agentFiles() {
  const dir = path.join(ROOT, "agents");
  if (!isDir(dir)) return [];
  return fs.readdirSync(dir)
    .filter((name) => name.endsWith(".md"))
    .map((name) => path.join(dir, name));
}

function commandFiles() {
  const dir = path.join(ROOT, "commands");
  if (!isDir(dir)) return [];
  return fs.readdirSync(dir)
    .filter((name) => name.endsWith(".md") && name !== "README.md")
    .map((name) => path.join(dir, name));
}

/** Recursively find all files named `hooks.json` under a directory. */
function findHooksJson(dir) {
  if (!isDir(dir)) return [];
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      results.push(...findHooksJson(p));
    } else if (entry.isFile() && entry.name === "hooks.json") {
      results.push(p);
    }
  }
  return results;
}

function checkHooks() {
  const dir = path.join(ROOT, "hooks");
  for (const p of findHooksJson(dir)) {
    try {
      JSON.parse(read(p));
    } catch (e) {
      err(`${rel(p)}: invalid JSON — ${e.message}`);
    }
  }
}

function main() {
  checkPlugin();
  checkMarketplace();

  const skills = skillFiles();
  if (skills.length === 0) err("no skills/*/SKILL.md found");
  checkFrontmatterFiles(skills);
  checkFrontmatterFiles(agentFiles());
  checkFrontmatterFiles(commandFiles());
  checkHooks();

  if (errors.length) {
    console.log(`VALIDATION FAILED (${errors.length} problem(s)):`);
    for (const e of errors) console.log(`  - ${e}`);
    process.exit(1);
  }
  console.log("All checks passed.");
}

main();
