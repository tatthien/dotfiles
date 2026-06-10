# Code Smells & Refactoring Moves

A code smell is a surface indication of a deeper structural problem. Smells don't
necessarily mean the code is wrong - they signal that refactoring might improve the
design. Always use judgment: not every smell needs fixing.

---

## Function-level smells

### Long Function
- **Symptom:** Function exceeds 20 lines or requires comments to separate sections
- **Refactoring:** Extract Method - pull each section into a named function
- **Signal phrases:** "this function does X, then Y, then Z"

### Too Many Arguments
- **Symptom:** Function takes 3+ arguments
- **Refactoring:**
  - 0 args (niladic) - ideal
  - 1 arg (monadic) - good
  - 2 args (dyadic) - acceptable
  - 3 args (triadic) - needs justification
  - 4+ args - introduce a parameter object or builder

```typescript
// Bad: 5 arguments
function createUser(name: string, email: string, age: number, role: string, department: string) { ... }

// Good: parameter object
function createUser(userData: CreateUserRequest) { ... }
```

### Flag Arguments
- **Symptom:** Boolean parameter that makes the function do two different things
- **Refactoring:** Split into two functions with clear names

```typescript
// Bad
render(data, true)   // what does true mean?

// Good
renderForPrint(data)
renderForScreen(data)
```

### Side Effects
- **Symptom:** Function name suggests it does X but it also secretly does Y
- **Refactoring:** Either rename to reflect all effects or extract the side effect

### Dead Code
- **Symptom:** Unreachable code, unused variables, commented-out blocks
- **Refactoring:** Delete it. Version control has the history if you need it back.

---

## Class-level smells

### Large Class (God Object)
- **Symptom:** Class has too many instance variables, too many methods, or does
  too many unrelated things
- **Refactoring:** Extract Class - group related fields and methods into new classes
- **Test:** Can you describe the class's purpose in one sentence without "and"?

### Feature Envy
- **Symptom:** A method uses more data from another class than from its own
- **Refactoring:** Move Method - put the method in the class whose data it uses most

```typescript
// Bad: OrderPrinter is envious of Order's data
class OrderPrinter {
  format(order: Order): string {
    return `${order.customer.name}: ${order.total()} (${order.items.length} items)`;
  }
}

// Better: Move the formatting to Order
class Order {
  summary(): string {
    return `${this.customer.name}: ${this.total()} (${this.items.length} items)`;
  }
}
```

### Data Clumps
- **Symptom:** The same group of variables appears together in multiple places
- **Refactoring:** Extract a class or named tuple for the group

```typescript
// Bad: start_x, start_y, end_x, end_y appear together everywhere
function drawLine(startX: number, startY: number, endX: number, endY: number) {}

// Good: introduce Point
function drawLine(start: Point, end: Point) {}
```

### Primitive Obsession
- **Symptom:** Using primitive types (string, int) for domain concepts
- **Refactoring:** Replace with a value object

```typescript
// Bad
const phoneNumber: string = "555-1234";
const zipCode: string = "90210";

// Good
const phone = new PhoneNumber("555-1234");  // validates format
const zip = new ZipCode("90210");           // validates format
```

### Refused Bequest
- **Symptom:** Subclass inherits methods/properties it doesn't want or use
- **Refactoring:** Replace inheritance with composition, or push unused methods
  down to siblings that actually need them

---

## Structural smells

### Duplicated Code
- **Symptom:** Same or similar logic in two or more places
- **Refactoring:**
  - Same class: Extract Method
  - Sibling classes: Extract to parent or shared utility
  - Unrelated classes: Extract to a standalone function
- **Warning:** Don't extract prematurely. Two occurrences might be coincidental
  similarity. Three is a pattern.

### Divergent Change
- **Symptom:** One class is modified for many different reasons
- **Refactoring:** Split the class by responsibility (apply SRP)

### Shotgun Surgery
- **Symptom:** One change requires small edits across many classes
- **Refactoring:** Consolidate the scattered logic into one class

### Speculative Generality
- **Symptom:** Abstract classes, interfaces, parameters, or hooks that exist
  "just in case" but have only one implementation
- **Refactoring:** Remove it. You Aren't Gonna Need It (YAGNI). Add abstraction
  when the second use case actually appears.

### Inappropriate Intimacy
- **Symptom:** Two classes access each other's private details excessively
- **Refactoring:** Move methods and fields to reduce coupling, or introduce a
  mediator between them

---

## Comment smells

### Redundant Comment
```typescript
// Bad: adds nothing the code doesn't already say
i++; // increment i
```

### Mandated Comment
```typescript
// Bad: forced doc comment that just restates the signature
/** Sets the name. @param name the name */
setName(name: string): void { this.name = name; }
```

### Commented-Out Code
```typescript
// Bad: dead code hiding in comments
// const total = calculateLegacyTotal(order);
const total = calculateTotal(order);
```
Delete it. Git has history.

### Journal Comments
```typescript
// Bad: changelog in the file
// 2024-01-15 - Added validation
// 2024-02-01 - Fixed null check
```
That's what git log is for.

---

## Refactoring decision guide

1. **Is there a test for this code?** If no, write one first. Never refactor
   without tests.
2. **What smell do I see?** Name it specifically.
3. **What's the minimal refactoring move?** Don't restructure the world.
4. **Does the refactoring make the code more readable?** If not, revert it.
5. **Do the tests still pass?** If not, the refactoring introduced a bug.
