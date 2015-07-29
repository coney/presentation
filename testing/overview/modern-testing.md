## Modern Testing Overview


## Unit Testing

> **Unit testing** is a software development process in which the smallest testable parts of an application, called units, are individually and independently scrutinized for proper operation.


- Testing Framework
  - JUnit, Google Test, Jasmine  

- Mocking Framework
  - Mockito, PowerMock, Google Mock, Sinon  

- Coverage
  - Jacoco, GCov, ‎Cobertura, Istanbul  


#### Testing Framework(JUnit)

``` java
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class CalculatorTest {
  @Test
  public void evaluatesExpression() {
    Calculator calculator = new Calculator();
    int sum = calculator.evaluate("1+2+3");
    assertEquals(6, sum);
  }
}
```


#### Mocking Framework(PowerMock)

``` java
@Test
public void demoStaticMethodMocking() throws Exception {
    mockStatic(IdGenerator.class);

    // setup mock expectation
    when(IdGenerator.generateNewId()).thenReturn(2L);

    new ClassUnderTest().methodToTest();

    // Optionally verify that the static method was actually called
    verifyStatic();
    IdGenerator.generateNewId();
}
```


#### Coverage Report


### Javascript Unit Testing
#### Testing Framework(Jasmine)
``` javascript
describe("A spec", function() {
  it("is just a function, so it can contain any code", function() {
    var foo = 0;
    foo += 1;

    expect(foo).toEqual(1);
  });

  it("can have more than one expectation", function() {
    var foo = 0;
    foo += 1;

    expect(foo).toEqual(1);
    expect(true).toEqual(true);
  });
});
```


#### Mocking Framework(Jasmine)

```javascript
it("tracks that the spy was called", function() {
  var foo, bar, fetchedBar;
  foo = {
    setBar: function(value) { bar = value; },
    getBar: function() { return bar; }
  };
  spyOn(foo, "getBar").and.returnValue(745);
  foo.setBar(123);
  fetchedBar = foo.getBar();

  expect(foo.getBar).toHaveBeenCalled();
  expect(bar).toEqual(123);
  expect(fetchedBar).toEqual(745);
});
```


### Coverage Report(Istanbul)


### Node.js

> Node.js® is a platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications.


### Karma

> Karma is a JavaScript command line tool that can be used to spawn a web server which loads your application's source code and executes your tests.


### How Karma Works
- Spawns a web server to serve the javscript sources
- Starts a web browser that executes source code against test code
- Examines the results for each test against each browser
- Displays the results to the developer such that they can see which browsers and tests passed or failed


### Javascript Testing Example



### TDD
- Forces radical simplification of the code
- Forces you to write small classes focused on one thing
- Helps create loosely coupled code
- Refactoring Encourages Improvements


### Disadvantages?
- TDD is hard to learn, especially on your own.
- You can expect reduced productivity for 2-4 months after starting.
- The test cases you wrote may not be the right thing  that the users need


### BDD
> Behavior-driven development (or BDD) is an agile software development technique that encourages collaboration between developers, QA and non-technical or business participants in a software project.


### Gherkin Language

![gherkin-lang](res/lang.png)


``` javascript
describe("A spec", function() {
  it("is just a function, so it can contain any code", function() {
    var foo = 0;
    foo += 1;

    expect(foo).toEqual(1);
  });

  it("can have more than one expectation", function() {
    var foo = 0;
    foo += 1;

    expect(foo).toEqual(1);
    expect(true).toEqual(true);
  });
});
```


JAVA
``` java
test student
```


### From TDD TO BDD

![tdd-bdd](res/tdd-bdd.png)


### Cucumber

### UI Automation Testing Example

- Cucumber Ruby
- Selenium-Webdriver
- RSpec


### Pact
#### Integration Contract Test

![Integration Contract Test](res/contract-test.png)


### Consumer Driven Contract
#### Generate Contract

![pact-1](res/pact-1.png)


#### Verify Contract

![pact-2](res/pact-2.png)


### Example



### Continuous Integration(CI)

![CI](res/ci.png)


#### Visualisation(Dashboard)

![dashboard](res/dashboard.png)


## DONE
