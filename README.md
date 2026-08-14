# Sample GHA pipelines from the retro stickies

## Shared building blocks (no conflicts — used by both paradigms)
- **`build-image.yml`** — builds the Docker image exactly once per master push,
  tagged by commit SHA, reused across every environment.
  Covers: *"No more branch-out: build once, re-use with every env"*, and lets
  *"Master Build becomes green after a successful run"* without waiting on a
  downstream approval step.
- **`deploy-gitops.yml`** — reusable workflow that updates the GitOps repo and
  syncs Argo CD, using `git commit --allow-empty` so it's safe to rerun.
  Covers: *"Pipeline can be rerun without error."*

## Two competing versioning paradigms — split into separate entrypoints

These solve the same underlying pain (JEDIS's fragile auto-increment tag script)
in incompatible ways, so they're separate workflows rather than one:

| | `release-triggered-deploy.yml` (Paradigm 1) | `manual-version-deploy.yml` (Paradigm 2) |
|---|---|---|
| Trigger | GitHub Release published | `workflow_dispatch` form |
| Versioning source of truth | none — deploys by commit SHA | semantic git tag, chosen by owner |
| Covers stickies | "Leverage GitHub Release feature", "owner specifies commit via UI", "owners specify version instead of JEDIS calculating it" | "specify desired release version through UI", "can specify release/tag version number" |
| "No more than 1 tag per commit" | enforced implicitly (no auto tags at all) | enforced explicitly with a guard step |

**Recommendation:** pick one as the team's actual answer to "how do we stop the
version script from breaking" — running both against the same service would
reintroduce the exact same-commit/duplicate-tag bug discussed in the meeting.
Paradigm 1 removes the versioning script problem entirely; Paradigm 2 keeps
semantic versioning but moves the decision to the owner.

## Not modeled as workflows (process/decision items, not pipeline code)
- *"Gemma to setup workshop with service owners for their consult"* — action item.
- *"Earth to think about how this might look as a long-term design"* — design task.
- *"[Hold for now] ticket to investigate transparent service version to Datadog"* — parked.
- *"Team to think about allowing owners to manage releases without git tags/auto-increment"*
  — this is the open question the two paradigms above are candidate answers to.
