# Pull request examples

## Titles

Bad titles. They give no scope or effect:

- "Fixed bug"
- "updates"
- "changes to auth"

Good titles. They use the Conventional Commits form and the imperative mood:

- `fix(auth): refresh token when the API returns 401`
- `feat(build): rechunk the image with chunkah`
- `docs(readme): add the local build steps`

## Body

Bad body. It gives no motivation, no test steps, and no scope:

```markdown
Fixed the thing. See ticket.
```

Good body. It answers why, what, and how to test. It is scannable:

```markdown
## Why

Sessions dropped after one hour. The client did not refresh the access token
when the API returned 401.

## What

- Add a token-refresh step to the request middleware.
- Retry the original request one time after a refresh.

## How to test

1. Run `just test auth`.
2. Log in. Wait for the token to expire. Send a request.
3. Confirm the request succeeds and the log shows one refresh.

## Risks and follow-ups

Low risk. The retry runs one time only. Follow-up: add a metric for refresh
failures.

## Links

Closes #482.
```
