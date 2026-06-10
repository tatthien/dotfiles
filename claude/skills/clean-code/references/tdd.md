# Test-Driven Development (TDD)

TDD is a discipline where tests drive the design of the code. You write the test
first, watch it fail, make it pass with minimal code, then refactor. This cycle
produces code that is only as complex as needed and always has test coverage.

---

## The Three Laws of TDD

1. **You may not write production code until you have written a failing test.**
2. **You may not write more of a test than is sufficient to fail** (compilation
   failures count as failures).
3. **You may not write more production code than is sufficient to pass the
   currently failing test.**

These laws create a tight feedback loop: red-green-refactor cycles of 1-5 minutes.

---

## Red-Green-Refactor

### Red
Write a test that describes the behavior you want. Run it. It must fail.
If it passes, either the behavior already exists or the test is wrong.

```typescript
it("new account has zero balance", () => {
  const account = new Account();
  expect(account.balance).toBe(0);
});
```

### Green
Write the simplest, most naive code that makes the test pass. Don't optimize.
Don't handle edge cases you haven't tested yet. Just make it green.

```typescript
class Account {
  balance = 0;
}
```

### Refactor
With the test green, clean up both production and test code. Remove duplication,
improve names, extract methods. The tests protect you - if you break something,
you'll know immediately.

---

## What makes a clean test

### FIRST Principles

| Principle | Meaning |
|---|---|
| **F**ast | Tests should run in milliseconds. Slow tests don't get run. |
| **I**ndependent | Tests must not depend on each other's execution order. |
| **R**epeatable | Same result every time, in any environment. No external dependencies. |
| **S**elf-validating | Pass or fail - no manual log inspection to determine the result. |
| **T**imely | Written just before the production code, not after. |

### Arrange-Act-Assert (AAA)

Every test should have exactly three sections:

```typescript
it("deposit increases balance", () => {
  // Arrange
  const account = new Account();

  // Act
  account.deposit(100);

  // Assert
  expect(account.balance).toBe(100);
});
```

Keep each section small. If Arrange is long, extract a factory or builder.
If Act is more than one line, the API might be too complex.

### One assert per concept

A test should verify one behavioral concept. Multiple asserts are fine if they
all verify the same concept from different angles:

```typescript
// Good: one concept (user creation) verified from multiple angles
it("creates a user", () => {
  const user = createUser("Alice", "alice@test.com");
  expect(user.name).toBe("Alice");
  expect(user.email).toBe("alice@test.com");
  expect(user.isActive).toBe(true);
});
```

```typescript
// Bad: two unrelated concepts in one test
it("user operations", () => {
  const user = createUser("Alice", "alice@test.com");
  expect(user.name).toBe("Alice");       // concept 1: creation
  user.deactivate();
  expect(user.isActive).toBe(false);     // concept 2: deactivation
});
```

---

## Test naming

Tests should read as behavior specifications. Group with `describe` and phrase
each `it` as `<action> <scenario> <expected result>`:

```typescript
describe("Account", () => {
  it("reduces balance when withdrawing with sufficient funds", () => { ... });
  it("throws InsufficientFunds when withdrawing more than the balance", () => { ... });
  it("has zero balance for a new account", () => { ... });
});
```

Avoid generic names like `it("withdraw 1")`, `it("edge case")`, or `it("bug fix")`.

---

## What to test

### Test behavior, not implementation

```typescript
// Bad: tests implementation detail (internal array structure)
it("add item", () => {
  const cart = new Cart();
  cart.add(item);
  expect(cart["items"][0]).toBe(item);    // reaching into private state
});

// Good: tests observable behavior
it("add item", () => {
  const cart = new Cart();
  cart.add(item);
  expect(cart.itemCount()).toBe(1);
  expect(cart.contains(item)).toBe(true);
});
```

### Test boundaries, not internals

Focus tests on:
- **Public API** - the contract other code depends on
- **Edge cases** - empty inputs, zero, negative, maximum values
- **Error paths** - what happens when things go wrong
- **Business rules** - the logic that encodes domain requirements

Don't test:
- Private methods (test them through the public API)
- Framework behavior (trust that your ORM saves correctly)
- Trivial getters/setters (unless they have logic)
- Implementation details that could change during refactoring

---

## Test doubles

Use the right kind of test double for the situation:

| Double | Purpose | Example |
|---|---|---|
| **Stub** | Returns canned answers | `paymentGateway.charge() -> Success` |
| **Mock** | Verifies interactions | `expect(mailer.send).toHaveBeenCalledWith(email)` |
| **Fake** | Working implementation (simplified) | In-memory database |
| **Spy** | Records calls for later assertion | `expect(spy).toHaveBeenCalledTimes(3)` |

**Prefer stubs over mocks.** Mocks create tight coupling to implementation.
If you refactor how a method achieves its result, mock-heavy tests break even
though behavior is unchanged.

**Prefer fakes for infrastructure.** An in-memory repository is better than
mocking every database call.

---

## Common TDD mistakes

| Mistake | Problem | Fix |
|---|---|---|
| Writing tests after code | Loses the design feedback TDD provides | Commit to red-green-refactor |
| Testing private methods | Couples tests to implementation | Test through public API |
| Too many mocks | Tests break on refactoring, test nothing real | Use fakes, test fewer layers |
| Skipping the refactor step | Accumulates mess in both test and production code | Refactor is not optional |
| Tests that mirror implementation | `expect(mock.method).toHaveBeenCalledWith(x, y, z)` for every line | Test outcomes, not call sequences |
| Not running tests frequently | Long feedback loops, harder to find what broke | Run after every small change |
