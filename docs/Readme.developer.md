# Developer Readme

## CI/CD Instructions

### Git push force test

```bash
git push -o ci.variable="FORCE_TEST=true"
```

### Git push without running pipelines

```bash
git push -o ci.skip
```
