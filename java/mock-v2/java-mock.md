# Java Mocking
note: reference from https://github.com/macdao/presentations/blob/gh-pages/huawei-mock.md



## Fizz Buzz Whizz

你是一名体育老师，在某次课距离下课还有五分钟时，你决定搞一个游戏。

首先你说出三个不同的特殊数, 要求必须是个位数, 比如3, 5, 7.

此时上课的100名学生拍成一队, 按顺序进行报数.


### 规则一
- 如果所报数字是第一个特殊数(3)的倍数, 那么不能说该数字, 而要说Fizz
- 如果所报数字是第二个特殊数(5)的倍数, 那么要说Buzz
- 如果所报数字是第三个特殊数(7)的倍数, 那么要说Whizz.


### 规则二
- 如果所报数字同时是两个特殊数的倍数情况下, 那么不能说该数字, 而是要说FizzBuzz, 以此类推.
- 例如要报15的同学数字同时是第一个特殊数(3)和第二个特殊数(5)的倍数, 所以要说FizzBuzz.
- 如果所报数字同时是三个特殊数的倍数, 那么要说FizzBuzzWhizz.


### 规则三
- 如果所报数字包含了第一个特殊数, 那么也不能说该数字, 同时忽略规则一和规则二, 而是要说相应的单词.
- 例如要报13的同学数字中包含了第一个特殊数(3), 所以应该说Fizz, 而不是13.
- 例如要报35的同学数字中包含了第一个特殊数(3), 所以应该说Fizz, 而不是BuzzWhizz.



### 实现

``` java
public class Student {
    public String say(int number) {
        return Integer.toString(number);
    }
}

@Test
public void shouldSayNumberDirectly() throws Exception {
    Student student = new Student();
    assertThat(student.say(1), is("1"));
    assertThat(student.say(2), is("2"));
    assertThat(student.say(4), is("4"));
}
```


### 规则一

```java
public class Student {
    public String say(int number) {
        if (number % 3 == 0) {
            return "Fizz";
        } else if (number % 5 == 0) {
            return "Buzz";
        } else if (number % 7 == 0) {
            return "Whizz";
        }
        return Integer.toString(number);
    }
}

@Test
public void shouldSayCorrespondingWordIfNumberIsAMultipleOfSpecialNumber() {
    Student student = new Student();
    assertThat(student.say(3), is("Fizz"));
    assertThat(student.say(5), is("Buzz"));
    assertThat(student.say(7), is("Whizz"));
}
```

### 规则二

```java
public class Student {
    public String say(int number) {
        StringBuilder sb = new StringBuilder();

        if (number % 3 == 0) {
            sb.append("Fizz");
        }
        if (number % 5 == 0) {
            sb.append("Buzz");
        }
        if (number % 7 == 0) {
            sb.append("Whizz");
        }
        return sb.length() != 0 ? sb.toString() : Integer.toString(number);
    }
}

@Test
public void shouldSayCorrespondingWordsIfNumberIsAMultipleOfMultipleNumbers() {
    Student student = new Student();
    assertThat(student.say(3 * 5), is("FizzBuzz"));
    assertThat(student.say(5 * 7), is("BuzzWhizz"));
    assertThat(student.say(3 * 3 * 5 * 7), is("FizzBuzzWhizz"));
}

```


### 规则三

```java

public class Student {
    public String say(int number) {
        StringBuilder sb = new StringBuilder();

        if (Integer.toString(number).contains("3")) {
            return "Fizz";
        }

        if (number % 3 == 0) {
            sb.append("Fizz");
        }
        if (number % 5 == 0) {
            sb.append("Buzz");
        }
        if (number % 7 == 0) {
            sb.append("Whizz");
        }

        return sb.length() != 0 ? sb.toString() : Integer.toString(number);
    }
}

@Test
public void shouldSayFizzIfNumberContains3() {
    Student student = new Student();
    assertThat(student.say(13), is("Fizz"));
    assertThat(student.say(23), is("Fizz"));
    assertThat(student.say(35), is("Fizz"));
}

@Test
public void shouldSayCorrespondingWordsIfNumberIsAMultipleOfMultipleNumbers() {
    Student student = new Student();
    assertThat(student.say(15), is("FizzBuzz"));
    assertThat(student.say(35), is("BuzzWhizz"));
    assertThat(student.say(105), is("FizzBuzzWhizz"));
}
```


# OCP(开放封闭原则)
![ocp](resources/ocp.jpg)

``` java
public class Student {
    private List<Rule> rules;
    public Student(Rule... rules) {
        this.rules = ImmutableList.copyOf(rules);
    }
    public String say(int number) {
        for (Rule rule : rules) {
            Optional<String> result = rule.apply(number);
            if (result.isPresent()) {
                return result.get();
            }
        }

        throw new IllegalStateException();
    }
}
```


<!-- .slide: data-background="white" -->
### 重构

```java
private List<GameRule> rules;

public String say() {
    for (GameRule rule : rules) {
        final Optional<String> result = rule.say(index);
        if (result.isPresent()) {
            return result.get();
        }
    }

    throw new IllegalStateException();
}
```


``` java
class DefaultRule implements Rule {
    public Optional<String> apply(int number) {
        return Optional.of(Integer.toString(number));
    }
}

@Test
public void shouldSayNumberDirectly() throws Exception {
    Student student = new Student(new DefaultRule());
    assertThat(student.say(1), is("1"));
    assertThat(student.say(2), is("2"));
    assertThat(student.say(4), is("4"));
}
```


``` java
public class MultipleNumberRule implements Rule {

    public Optional<String> apply(int number) {
        StringBuilder sb = new StringBuilder();
        if (number % 3 == 0) sb.append("Fizz");
        if (number % 5 == 0) sb.append("Buzz");
        if (number % 7 == 0) sb.append("Whizz");
        return Optional.fromNullable(sb.length() == 0 ? null : sb.toString());
    }
}

@Test
public void shouldSayCorrespondingWordsIfNumberIsAMultipleOfMultipleNumbers() {
    Student student = new Student(new MultipleNumberRule(), new DefaultRule());
    assertThat(student.say(15), is("FizzBuzz"));
    assertThat(student.say(35), is("BuzzWhizz"));
    assertThat(student.say(105), is("FizzBuzzWhizz"));
}
```


``` java
public class SpecialNumberRule implements Rule {
    public Optional<String> apply(int number) {
        if (Integer.toString(number).contains("3")) {
            return Optional.of("Fizz");
        } else {
            return Optional.absent();
        }
    }
}
@Test
public void shouldSayFizzIfNumberContains3() {
    Student student = new Student(new SpecialNumberRule(), new MultipleNumberRule(), new DefaultRule());
    assertThat(student.say(13), is("Fizz"));
    assertThat(student.say(23), is("Fizz"));
    assertThat(student.say(35), is("Fizz"));
}
```


### 问题
- 如果规则改变, 遇到3的倍数返回Buzz, 遇到5的倍数返回Buzz
- 新增规则, 遇到2的倍数返回Jazz
``` java
public class Student {
    private List<Rule> rules;
    public Student(Rule... rules) {
        this.rules = ImmutableList.copyOf(rules);
    }

    public String say(int number) {
        for (Rule rule : rules) {
            Optional<String> result = rule.apply(number);
            if (result.isPresent()) {
                return result.get();
            }
        }

        throw new IllegalStateException();
    }
}
```


# SUT
- System Under Test


## SpecialNumberRule的测试

- Case 1
 - Given一个数字
 - When数字中包含3
 - Then返回Fizz

- Case 2
 - Given一个数字
 - When数字中没有3
  - Then不返回内容


``` java
public class SpecialNumberRuleTest {
    @Test
    public void shoudReturnFizzIfNumberContains3() throws Exception {
        SpecialNumberRule rule = new SpecialNumberRule();
        assertThat(rule.apply(3).get(), is("Fizz"));
        assertThat(rule.apply(13).get(), is("Fizz"));
    }

    @Test
    public void shoudReturnNothingIfNumberDoesNotContain3() throws Exception {
        SpecialNumberRule rule = new SpecialNumberRule();
        assertThat(rule.apply(5).isPresent(), is(false));
        assertThat(rule.apply(15).isPresent(), is(false));
    }
}
```


## Student的测试

- Case 1
 - Given两个规则
 - When第一个规则返回了Fizz
 - Then返回Fizz

- Case 2
 - Given两个规则
 - When第一个规则没有返回值
 - And第二个规则返回了Buzz
 - Then返回Buzz


### 通过假实现完成Student的测试
``` java
@Test
public void shouldSayWordAccrodingToTheRules2() {
    Student student = new Student(new Rule() {
        public Optional<String> apply(int number) {
            return Optional.fromNullable(number == 3 ? "Fizz" : null);
        }
    }, new Rule() {
        public Optional<String> apply(int number) {
            return Optional.of("Buzz");
        }
    });

    assertThat(student.say(3), is("Fizz"));
    assertThat(student.say(5), is("Buzz"));
}
```


<!-- .slide: data-background="white" -->
### 通过Mock完成Student的测试
``` java
@Test
public void shouldSayWordAccrodingToTheRules3() {
    Rule rule1 = mock(Rule.class);
    when(rule1.apply(anyInt())).thenReturn(Optional.<String>absent());
    when(rule1.apply(2)).thenReturn(Optional.of("Fizz"));

    Rule rule2 = mock(Rule.class);
    when(rule2.apply(anyInt())).thenReturn(Optional.of("Buzz"));

    Student student = new Student(rule1, rule2);
    assertThat(student.say(3), is("Fizz"));
    assertThat(student.say(5), is("Buzz"));
}
```



# Mock
![fake-person](resources/fake-person.jpg)


## Mockito

```java
import static org.mockito.Mockito.*;

List<String> mockedList = mock(List.class);

when(mockedList.get(0)).thenReturn("first");
when(mockedList.get(1)).thenThrow(new RuntimeException());

assertThat(mockedList.get(0), is("first"));

```


## Test Double

- Dummy

 Objects are passed around but never actually used. Usually they are just used to fill parameter lists.

- Fake

 Objects actually have working implementations, but usually take some shortcut which makes them not suitable for production (an in memory database is a good example).


- Stubs

 Provide canned answers to calls made during the test, usually not responding at all to anything outside what's programmed in for the test. Stubs may also record information about calls, such as an email gateway stub that remembers the messages it 'sent', or maybe only how many messages it 'sent'.

- Mocks

 Objects pre-programmed with expectations which form a specification of the calls they are expected to receive.


## Mockito Stub

```java
Car boringStubbedCar = when(mock(Car.class).shiftGear())
        .thenThrow(EngineNotStarted.class)
        .getMock();

doThrow(new RuntimeException()).when(mockedList).clear();
```


## Mockito Mock

```java
List mockedList = mock(List.class);

mockedList.add("one");
mockedList.clear();

verify(mockedList).add("one");
verify(mockedList).clear();
```


## Argument matchers

```java
when(mockedList.get(anyInt())).thenReturn("element");

assertThat(mockedList.get(999), is("element"));

verify(mockedList).get(anyInt());
```


## Verifying number of invocations

```java
mockedList.add("twice");
mockedList.add("twice");

mockedList.add("three times");
mockedList.add("three times");
mockedList.add("three times");

verify(mockedList, times(2)).add("twice");

verify(mockedList, never()).add("never happened");
verify(mockedList, atLeastOnce()).add("three times");
verify(mockedList, atLeast(2)).add("five times");
verify(mockedList, atMost(5)).add("three times");
```


``` java
public class WeatherNotifier
{
    private HttpClient client;

    public WeatherNotifier(HttpClient client)
    {
        this.client = client;
    }

    void check()
    {
        if (getWeather().equals("rain"))
        {
            sendNotification();
        }
    }

    private void sendNotification()
    {
        client.post("/sms-gateway", String.format("number=%s&content=%s", "13012345678", "raining"));
    }

    private String getWeather()
    {
        String weatherJson = client.get("/weather-api", "location=xian");
        return new JsonParser().parse(weatherJson).getAsJsonObject().get("weather").getAsString();
    }
}
```


``` java
public class WeatherNotifierTest
{
    @Test public void shouldSendNotificationWhenRaining() throws Exception
    {
        HttpClient httpClient = mock(HttpClient.class);

        when(httpClient.get("/weather-api", "location=xian")).thenReturn("{weather: \"rain\"}");
        new WeatherNotifier(httpClient).check();

        verify(httpClient, times(1)).post("/sms-gateway", "number=13012345678&content=raining");
    }

    @Test public void shouldNotSendNotificationWhenItIsSunny() throws Exception
    {
        HttpClient httpClient = mock(HttpClient.class);

        when(httpClient.get("/weather-api", "location=xian")).thenReturn("{weather: \"sunny\"}");
        new WeatherNotifier(httpClient).check();

        verify(httpClient, times(0)).post(anyString(), anyString());
    }
}
```

# 参考资料

- [SOLID](https://en.wikipedia.org/wiki/SOLID_%28object-oriented_design%29)
- [Inversion of Control Containers and the Dependency Injection pattern](http://www.martinfowler.com/articles/injection.html)
- [Mocks Aren't Stubs](http://martinfowler.com/articles/mocksArentStubs.html)
- [Mockito](http://site.mockito.org/mockito/docs/current/org/mockito/Mockito.html)
