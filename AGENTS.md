# AGENTS.md

# Cursor Cloud specific instructions

_These instructions are specific to Cursor Cloud Agents._

## Before Starting

**VITAL. RUN BEFORE MAKING ANY CHANGES.**

### 1) Install dependencies

The `@alayacare` npm packages are hosted on **AWS CodeArtifact** (domain: `alayacare`, owner: `406883902139`, region: `us-east-1`, repository: `alaya-npm`). Before running `npm install` or `npm ci`, you must authenticate:

```sh
export AWS_ACCESS_KEY_ID="$CODEARTIFACT_AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$CODEARTIFACT_AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="$CODEARTIFACT_AWS_DEFAULT_REGION"
aws codeartifact login --tool npm --repository alaya-npm --domain alayacare --domain-owner 406883902139 --namespace @alayacare
nvm install 22 && nvm use 22 && npm install
```

The `awscli` pip package must be installed (it is included in the VM snapshot). The token expires after 12 hours.


### 2) Start the dev server & Chrome

Start the dev server in the background:
```bash
nohup npm run dev > npm-run-dev.log 2>&1 &
```

Open Chrome to the dev server URL:
```bash
./scripts/run-chrome.sh http://localhost:5173
```

Do **not** launch Chrome directly outside this script, or use headless automation.


## After Work

**VITAL. RUN AFTER MAKING ANY CHANGES.**

- **Commit and push** all changes so work is saved. CircleCI will deploy automatically on push.
- Do not provide a link to the pull request. This repository is for non-technical users.
- Return a shareable preview link to the user in Markdown format
- Let the user know the shareable preview will be ready in around 2 minutes

### Shareable link

To build the link, use the following pattern:
- Use this format: `https://alayacare.github.io/accloud-prototype-template/<slugified-branch-name>/`
- With a slugified branch name (replace non-alphanumeric characters with dashes):

Example: branch `cursor/dog-breeds-datatable-fe12` → `https://alayacare.github.io/accloud-prototype-template/cursor-dog-breeds-datatable-fe12/`


## Gotchas

- There are no automated tests configured in this template (no test runner or test scripts).
- There is no linter (ESLint) configured — `npm run type-check` is the primary code-quality check.
- The `vite-plugin-vue-devtools` import is commented out in `vite.config.ts` by default; the plugin may cause issues in headless environments.
- MSW starts unconditionally in `src/main.ts` (not gated behind `import.meta.env.DEV`), so it runs in all build modes.
- The production build emits large chunks (>500 kB); this is expected for the design system bundle and does not indicate a problem.
