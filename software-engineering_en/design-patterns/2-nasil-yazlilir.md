# How to Write Design Patterns? (Design Patterns 2)

Hello friends,

In our previous article, we talked about the kinds of mistakes we make while trying to learn design patterns and and the techniques that can be applied to make them stick better. In this article, we're continuing from where we left off. Our goal is to be able to explain how to build a design pattern in a sentence or two. This way, with an explanation stripped of details, we'll also make them stick better in our minds.

In the next article, we'll touch on the points where design patterns have structural and purposeful things in common or where they differ from each other. Since we'll touch on the relationships of each design pattern we examine with other patterns, being able to give short answers to at least the questions of what each one's purpose is and how it's written will make our job a lot easier.


Now let's continue by adding to the point where we left off in the previous article.

### Creational Design Patterns


They're patterns that create objects instead of instantiating objects directly. This gives the program more flexibility in deciding which objects need to be created for a particular situation.

- **Singleton**: 
  
**Purpose:** Restricts object creation for a class to one instance. To put it a bit differently, it ensures that a single object is used by all the objects that need it. 
  
**Example:** For example, like everyone in the house using the fridge at home, or a group of neighbors on the street sharing a garbage container. When we need this kind of object while coding, the design pattern that will guarantee it is singleton.

**How It's Done**: in the first condition, for all requests that need the object, it's checked whether the object has been created. If there's no instance of the object yet, a lock statement is written on an object, and a second condition is placed inside this statement against the possibility of more than one request getting in, and if the instance still hasn't been created, it's created. As the requests that finish their work inside the lock exit the lock statement, every incoming request will see that the object has been created, so the object won't be created again. 

**Key Code Block**

```c#

private static readonly object _lock = new object();

public static Singleton GetInstance(string value)
    {
        if (_instance == null)
        {
            lock (_lock)
            {
                if (_instance == null)
                {
                    _instance = new Singleton();
                }
            }
        }
        return _instance;
    }
```



- **Factory Method**: 
  
**Purpose:** Used to create instances from different classes derived from the same interface. It's a single method. 
  
**Example:** For example, let's think of a factory that produces different models of the same car brand.

**How Is It Done?:** All the objects to be created are derived from the same interface. Then the related object is created with a method inside a factory object that is also derived from an interface.

**Key Code Block**

```c#
public interface IGuiFactory
{
	public IComponent CreateButton(string color);
	public IComponent CreateTextBox(string color);
	public IComponent CreateTable(string color);
}

public class GuiFactory:IGuiFactory
{
	
	public IComponent CreateButton(string color)
	{
		var button = new Button(color);
		button.Draw();
		return button;
	}
	public IComponent CreateTextBox(string color)
	{
		var textBox = new TextBox(color);
		textBox.Draw();
		return textBox;
	
	}
	public IComponent CreateTable(string color)
	{
		var table = new Table(color);
		table.Draw();
		return table;
	}
}
```





- **Abstract Factory**: 

**Purpose:** Creates a group of related but different objects. It's a class, made up of multiple factory methods. It can even sometimes be made up of more than one factory class.

**Example:** For example, let's think of a factory where different models of different car brands are produced. You could even add a third dimension, for example, using different factories to produce different models of different brands for different countries.

**How Is It Done?:** All the objects to be created are derived from the same interface. Then the related objects are created with multiple methods inside a factory object that is also derived from an interface. If you want to produce more than one factory, more factory objects can be produced too.

**Key Code Block**

```c#
public interface IUniversityFactory
{
	University CreateUniversity(int id, string name);
	Course CreateCourse(int id, string name);
	Student CreateStudent(int id, string name, int age);
	Prof CreateProf(int id, string name, int age, Course course);
	
}

public interface IUniversityRemoteFactory
{
	UniversityRemote CreateUniversityRemote(int id, string name);
	CourseRemote CreateCourseRemote(int id, string name);
	Student CreateStudent(int id, string name, int age);
	ProfRemote CreateProfRemote(int id, string name, int age, CourseRemote course);
	
}

public class Program
{
    public static void Main()
    {
		
		var universityFactory=new UniversityFactory();
		
		var university = universityFactory.CreateUniversity(1, "University 1");
		var course = universityFactory.CreateCourse(1, "Course 1");
		var prof = universityFactory.CreateProf(1,"Ahmet",45,course);
		var student = universityFactory.CreateStudent(1,"Mehmet",45);
		
		university.AddStudent(student);
        university.AddCourse(course);
        university.AddProf(prof);
		

    	var universityRemoteFactory = new UniversityRemoteFactory();
		
		var universityRemote = universityRemoteFactory.CreateUniversityRemote(1, "UniversityRemote 1");
		var courseRemote = universityRemoteFactory.CreateCourseRemote(1, "CourseRemote 1");
		var profRemote = universityRemoteFactory.CreateProfRemote(1,"Ahmet Remote",45,courseRemote);
		var studentRemote = universityFactory.CreateStudent(1,"Mehmet Remote",45);
		
		
		universityRemote.AddStudent(studentRemote);
        universityRemote.AddCourse(courseRemote);
        universityRemote.AddProf(profRemote);

    }
}

```


- **Builder**: 

**Purpose:** By separating the creation process/steps of a complex object from its representation, it allows different types of the same object to be created. 

**Example:** When we want to buy a car, we go to the dealership. We say which features we want, and after a certain time the car we want is produced at the factory and delivered. Naturally, the production process is complex; many tasks are completed in order, following certain processes. While the building of the car and its processes are done at the factory, its presentation and sale are done by the dealership.

**How Is It Done?:** In its simplest form, with one or more builder objects, the parts of the related objects are written so that they're created in different functions. Then, with a director object, one or more builder objects are passed as parameters to the function that will create the related object.

**Key Code Block**

An example of creating a single object

```c#
public interface IBuilder
    {
        void BuildPartA();
        
        void BuildPartB();
        
        void BuildPartC();
    }

public class Director
    {
        private IBuilder _builder;
        
        public Director(IBuilder builder)
        {
            _builder = builder
        }
        
        public IBuilder BuildFullFeaturedProduct()
        {
            this._builder.BuildPartA();
            this._builder.BuildPartB();
            this._builder.BuildPartC();

			return _builder;
        }
    }

 class Program
    {
        static void Main(string[] args)
        {
            IBuilder builder = new ConcreteBuilder();
            var director = new Director(builder);
            
            var concreteBuilder = director.BuildFullFeaturedProduct();
        }
    }
```


- **Prototype**: 

**Purpose:** Allows cloning/copying objects that are very costly to create from similar instances created before.

**Example:** When we go to a locksmith to copy a key, let's imagine for a moment that the locksmith asks for the lock cylinder of the door the key will be copied for, opens it up, measures the lengths millimeter by millimeter, calculates the angles of the key's teeth and produces the key for us according to this calculation. Since we now know about copying, this sounds so unnecessary, doesn't it? 

If we think about how much cpu,memory and network the system uses to produce some objects we easily create with a single line of code, we can understand how often we make this mistake. Since we're not the ones writing that code, it may feel as if there isn't that much work involved. But in a multi-user application where performance is important, an object being created by using the system and the network heavily can cause serious problems.

**How Is It Done?:** A copy function is defined inside the object to be copied, and a copy of the object is returned.

**Key Code Block**


```c#
public class Person
    {
        public int Age;
        public DateTime BirthDate;
        public string Name;
        public IdInfo IdInfo;

        public Person ShallowCopy()
        {
            return (Person) this.MemberwiseClone();
        }

        public Person DeepCopy()
        {
            Person clone = (Person) this.MemberwiseClone();
            clone.IdInfo = new IdInfo(IdInfo.IdNumber);
            clone.Name = String.Copy(Name);
            return clone;
        }
```



### Structural Design Patterns

- **Adapter**: 

**Purpose:** Allows two different interfaces to work together. 

**Example:** The adapters we use in real life do exactly the same job. The adapters we use to make the plug of an electronic device we bought from America fit the sockets in Turkey are an example of this.

**How Is It Done?:** Like the adapters we use in real life, an intermediate object is created, and the source object is passed to the adapter object as a parameter. The data the client expects is presented by transforming it from the received source object. 

**Key Code Block**

```c#
public interface ITarget
    {
        string GetRequest();
    }

    class Adaptee
    {
        public string GetSpecificRequest()
        {
            return "Specific request.";
        }
    }

    class Adapter : ITarget
    {
        private readonly Adaptee _adaptee;

        public Adapter(Adaptee adaptee)
        {
            this._adaptee = adaptee;
        }

        public string GetRequest()
        {
            return $"This is '{this._adaptee.GetSpecificRequest()}'";
        }
    }


class Program
    {
        static void Main(string[] args)
        {
            Adaptee adaptee = new Adaptee();
            ITarget target = new Adapter(adaptee);
            Console.WriteLine(target.GetRequest());
        }
    }


```



- **Bridge**: 

**Purpose:** Used to separate an object's abstraction from its implementation. This way, the two can be extended independently of each other.

**Example:** It's a bit hard to give a real-life example, but again, let's say no analogy is perfect and try to give an example. For example, let's say we're producing cars. It would be impossible for us to produce the cars in a way that meets the wishes of all customers. Instead, it would be less costly to produce the cars according to the technical documents we have (abstraction) with all the parts they basically need to have, and to get the features that vary from customer to customer from our customers during the purchase and complete the production. For example, the color, whether it has a sunroof or not.

**How Is It Done?:** It consists of two parts, abstraction and implementation. Part of the value the client requests is the part that doesn't change (abstraction), and the other part is the part that can be changed, that is, chosen on request (implementation). For example, we can write code that draws a shape, but we may need to let the client choose the color. For this, the abstraction part is written first, and the changing part is passed to the abstraction object as a parameter. 

**Key Code Block**

```c#
public interface IBridge
{
    void Function1();
    void Function2();
}

public interface IAbstractBridge
{
    void CallMethod1();
    void CallMethod2();
}

public class AbstractBridge : IAbstractBridge
{
    public IBridge bridge;

    public AbstractBridge(IBridge bridge)
    {
        this.bridge = bridge;
    }

    public void CallMethod1()
    {
        this.bridge.Function1();
    }

    public void CallMethod2()
    {
        this.bridge.Function2();
    }
}

```



- **Composite**: 

**Purpose:** If a parent-child (tree) relationship can be established between objects that have a common interface, it's used to abstract the client from the parts and let it deal with a single object.

**Example:** The goal is to create objects in a tree structure as a single composite object. Of course, libraries like this now exist in languages, but if we think about the dates the book was written, trying to explain it as a pattern seems to make sense. For example, you went to a dealership, asked the price of a car, and the salesperson started calculating the prices of all the parts one by one for you. Naturally, this would be very pointless. Of course, to calculate the price of a car, the prices of all the parts have to be known one by one, but as the buyer, this doesn't concern us.

**How Is It Done?:** The same interface is applied to all the elements in the hierarchical structure. Each element keeps the list of its child elements or the information of a single child element.


**Key Code Block**:


```c#
public interface IComponent
    {
        void DisplayPrice();
    }

public class Leaf : IComponent
    {
        public int Price { get; set; }
        public string Name { get; set; }
        public Leaf(string name, int price)
        {
            this.Price = price;
            this.Name = name;
        }
        
        public void DisplayPrice()
        {
            Console.WriteLine(Name +" : "+ Price);
        }
    }    

public class Composite : IComponent
    {
        public string Name { get; set; }
        List<IComponent> components = new List<IComponent>();
        public Composite(string name)
        {
            this.Name = name;
        }
        public void AddComponent(IComponent component)
        {
            components.Add(component);
        }
        
        public void DisplayPrice()
        {
            Console.WriteLine(Name);
            foreach (var item in components)
            {
                item.DisplayPrice();
            }
        }
    }

static void Main(string[] args)
        {

            IComponent hardDisk = new Leaf("Hard Disk", 2000);
            IComponent ram = new Leaf("RAM", 3000);
            IComponent cpu = new Leaf("CPU", 2000);
            IComponent mouse = new Leaf("Mouse", 2000);
            IComponent keyboard = new Leaf("Keyboard", 2000);

            Composite motherBoard = new Composite("Peripherals");
            Composite cabinet = new Composite("Cabinet");
            Composite peripherals = new Composite("Peripherals");
            Composite computer = new Composite("Computer");

            motherBoard.AddComponent(cpu);
            motherBoard.AddComponent(ram);

            cabinet.AddComponent(motherBoard);
            cabinet.AddComponent(hardDisk);

            peripherals.AddComponent(mouse);
            peripherals.AddComponent(keyboard);

            computer.AddComponent(cabinet);
            computer.AddComponent(peripherals);

            computer.DisplayPrice();
            Console.WriteLine();

            keyboard.DisplayPrice();
            Console.WriteLine();

            cabinet.DisplayPrice();
            Console.Read();
        }

```




- **Decorator**: 

**Purpose:** Used to dynamically add new responsibilities to an object or change them.

**Example:** It may not be a perfect example, but I think it will be memorable. For example, having LPG installed in our gasoline car could be an example of this.  

**How Is It Done?:**  The object itself is passed as a parameter to the decorator class, which implements the same interface as the object to be decorated.

**Key Code Block:**

```c#

public interface IPizza
    {
        string MakePizza();
    }

public class PlainPizza : IPizza
    {
        public string MakePizza()
        {
            return "Plain Pizza";
        }
    }
 public abstract class PizzaDecorator : IPizza
    {
        protected Pizza pizza;
        public PizzaDecorator(Pizza pizza)
        {
            this.pizza = pizza;
        }
        public virtual string MakePizza()
        {
           return pizza.MakePizza();
        }
    }

public class ChickenPizzaDecorator : PizzaDecorator
    {
        public ChickenPizzaDecorator(Pizza pizza) : base(pizza)
        {
        }
        public override string MakePizza()
        {
            return pizza.MakePizza() + AddChicken();
        }
        private string AddChicken()
        {
            return ", Chicken added";
        }
    }

public class VegPizzaDecorator : PizzaDecorator
    {
        public VegPizzaDecorator(Pizza pizza) : base(pizza)
        {
        }
        public override string MakePizza()
        {
            return pizza.MakePizza() + AddVegetables();
        }
        private string AddVegetables()
        {
            return ", Vegetables added";
        }
    }
class Program
    {
        static void Main(string[] args)
        {
            PlainPizza plainPizzaObj = new PlainPizza();
            string plainPizza = plainPizzaObj.MakePizza();
            Console.WriteLine(plainPizza);
            PizzaDecorator chickenPizzaDecorator = new ChickenPizzaDecorator(plainPizzaObj);
            string chickenPizza = chickenPizzaDecorator.MakePizza();
            Console.WriteLine("\n'" + chickenPizza + "' using ChickenPizzaDecorator");
            VegPizzaDecorator vegPizzaDecorator = new VegPizzaDecorator(plainPizzaObj);
            string vegPizza = vegPizzaDecorator.MakePizza();
            Console.WriteLine("\n'" + vegPizza + "' using VegPizzaDecorator");
            Console.Read();
        }
    }

```


- **Facade**: 
**Purpose:** Used to provide a simpler interface in order to be able to use very complex systems.

**Example:**For example, while driving a car, we don't know what's going on behind the steering wheel. Or while using a computer, all we know is the keyboard, mouse and monitor; we don't need to know the rest of the details.

**How Is It Done?:**  With the help of a function inside the class, the functions in other objects are called in order. 

**Key Code Block:** For example, another system can be built by calling functions from different subsystems. For example, to issue an invoice, we'll need the product details, the buyer information or the information on whether the payment has been made. By using this information, we issue the invoice. 

```c#

public class Product
{
    public void GetProductDetails()
    {
        Console.WriteLine("Fetching the Product Details");
    }
}

public class Payment
{
    public void MakePayment()
    {
        Console.WriteLine("Payment Done Successfully");
    }
}

public class Invoice
{
    public void Sendinvoice()
    {
        Console.WriteLine("Invoice Send Successfully");
    }
}

public class Order
    {
        public void PlaceOrder()
        {
            Console.WriteLine("Place Order Started");
            Product product = new Product();
            product.GetProductDetails();
            Payment payment = new Payment();
            payment.MakePayment();
            Invoice invoice = new Invoice();
            invoice.Sendinvoice();
            Console.WriteLine("Order Placed Successfully");
        }
    }


class Program
    {
        static void Main(string[] args)
        {
            Order order = new Order();
            order.PlaceOrder();
            Console.Read();
        }
    }

```

- **Flyweight**: 

**Purpose:** Used in creating objects that are small on their own but would be very costly when created in the hundreds.

**Example:**The solution is produced with the logic of "maybe there's no need to create that many objects, isn't there another way to do this?". For example, a car rental company can't buy a thousand cars for a thousand possible different customers. Instead, it rents a hundred cars to them at different times. In other words, the needs of a thousand customers are met, but this is done with a hundred cars. A property like which date the car will belong to whom isn't one of the car's intrinsic properties; it's just a state, and the same service is provided by changing it.

**How Is It Done?:**  First, to create the object, an interface or abstract class representing the related object is written. This interface offers functions for the parts that can be changed on the client side. These objects are usually created with the help of a factory and stored in a certain number (in list, array, dictionary, etc. objects). When the object is needed, it's read from the list and made available for use. The object that has finished its job is added back to the list. As long as all instances of the same object in the list aren't needed at the same time, there won't be a problem.

**Key Code Block:**  With the SetColor function, the color of the object can be changed by the client.

```c#

public interface IShape
    {
        void Draw();
    }

public class Circle : IShape
    {
        public string Color { get; set; }
        private int XCor = 10;
        private int YCor = 20;
        private int Radius = 30;
        
        public void SetColor(string Color)
        {
            this.Color = Color;
        }
        public void Draw()
        {
            Console.WriteLine(" Circle: Draw() [Color : " + Color + ", X Cor : " + XCor + ", YCor :" + YCor + ", Radius :"
                    + Radius);
        }
    }

public class ShapeFactory
    {
        private static Dictionary<string, Shape> shapeMap = new Dictionary<string, Shape>();
        public static Shape GetShape(string shapeType)
        {
            Shape shape = null;
            if (shapeType.Equals("circle", StringComparison.InvariantCultureIgnoreCase))
            {
                if (shapeMap.TryGetValue("circle", out shape))
                {
                }
                else
                {
                    shape = new Circle();
                    shapeMap.Add("circle", shape);
                    Console.WriteLine(" Creating circle object with out any color in shapefactory \n");
                }
            }
            return shape;
        }
    }


class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("\n Red color Circles ");
            for (int i = 0; i < 3; i++)
            {
                Circle circle = (Circle)ShapeFactory.GetShape("circle");
                circle.SetColor("Red");
                circle.Draw();
            }
            Console.WriteLine("\n Green color Circles ");
            for (int i = 0; i < 3; i++)
            {
                Circle circle = (Circle)ShapeFactory.GetShape("circle");
                circle.SetColor("Green");
                circle.Draw();
            }
            Console.WriteLine("\n Blue color Circles");
            for (int i = 0; i < 3; ++i)
            {
                Circle circle = (Circle)ShapeFactory.GetShape("circle");
                circle.SetColor("Green");
                circle.Draw();
            }
            Console.WriteLine("\n Orange color Circles");
            for (int i = 0; i < 3; ++i)
            {
                Circle circle = (Circle)ShapeFactory.GetShape("circle");
                circle.SetColor("Orange");
                circle.Draw();
            }
            Console.WriteLine("\n Black color Circles");
            for (int i = 0; i < 3; ++i)
            {
                Circle circle = (Circle)ShapeFactory.GetShape("circle");
                circle.SetColor("Black");
                circle.Draw();
            }
            Console.ReadKey();
        }
    }

```
- **Proxy**: 
**Purpose:** Used to stand in for the real object and do some work that the real object either can't do at all or does incompletely, without requiring any change on the client side.

**Example:** It can be used for things like logging, caching, security and performance. The best real-life example might be lawyers. They can carry out the defense on our behalf in a case that we can't handle or couldn't handle very well ourselves. Or when we give a power of attorney at a notary, we can have someone else do a job we can't do for some reason. Or, for example, just as we can withdraw money from the bank with our bank card, we can also withdraw money from an ATM. 

**How Is It Done?:**  A proxy object is written that implements the same interface as the object to be created. Depending on the need, additions and adjustments are made in the proxy class in a way that requires no change on the client side. 

**Key Code Block:** If you notice, the DisplayImage function exists both in the real object and in the proxy object. Inside the DisplayImage function, different operations can also be done before and after the real function runs. For example, the image can be fetched from the cache, or the user calling the image and the date can be logged.

```c#
public interface IImage
    {
        void DisplayImage();
    }

public class RealImage : IImage
    {
        private string Filename { get; set; }
        public RealImage(string filename)
        {
            Filename = filename;
            LoadImageFromDisk();
        }
        public void LoadImageFromDisk()
        {
            Console.WriteLine("Loading Image : " + Filename);
        }
        public void DisplayImage()
        {
            Console.WriteLine("Displaying Image : " + Filename);
        }
    }

public class ProxyImage : IImage
    {
        private RealImage realImage = null;
        private string Filename { get; set; }
        public ProxyImage(string filename)
        {
            Filename = filename;
        }
        public void DisplayImage()
        {
            if(realImage == null)
            {
                realImage = new RealImage(Filename);
            }
            realImage.DisplayImage();
        }
    }

class Program
    {
        static void Main(string[] args)
        {
            IImage Image1 = new ProxyImage("Tiger Image");
            
            Console.WriteLine("Image1 calling DisplayImage first time :");
            Image1.DisplayImage(); // loading necessary
            Console.WriteLine("Image1 calling DisplayImage second time :");
            Image1.DisplayImage(); // loading unnecessary
            Console.WriteLine("Image1 calling DisplayImage third time :");
            Image1.DisplayImage(); // loading unnecessary
            Console.WriteLine();
            IImage Image2 = new ProxyImage("Lion Image");
            Console.WriteLine("Image2 calling DisplayImage first time :");
            Image2.DisplayImage(); // loading necessary
            Console.WriteLine("Image2 calling DisplayImage second time :");
            Image2.DisplayImage(); // loading unnecessary
            Console.ReadKey();
        }
    }



```
### Behavioral Design Patterns

- **Chain of Responsibility**: 
**Purpose:** Allows a series of operations that need to be done on an object to be completed by the client, at its own decision, passing the object to the objects that can carry out the related responsibility.

**Example:** When we go to government offices, we need to get some things done in order. A document we have will have some tasks that need to be done in order, and according to these, some offices are visited, the tasks that office needs to do are done, and then we move on to the next office. In the final analysis, when all the tasks are done, our business is finished with each office's approval signature. For example, you want to withdraw money from a bank, or you're going to apply for a loan. When you start this application or the withdrawal, a series of operations is done one after another in a certain order. 

**How Is It Done?:**  Although it looks very similar to Builder, the most fundamental difference is that there the only goal is creating an object, while here the goal is completing some piece of work. A series of objects implementing the same interface is created. Each object is like a link in the chain. On the implemented interface there's a function that takes the next step as a parameter. The next step also has to implement the same interface, so the interface itself is given as the parameter. Also, on this interface there's another function that takes the object to be operated on or whose data will be used as a parameter and does the necessary operations. After doing the job, this function passes the object it received as a parameter to the function with the same name on the object representing the next step. As in the example below, it's also possible to use an abstract class instead of an interface.

**Key Code Block:** 

```c#
 
public abstract class Handler
    {
        protected Handler successor;
        public void SetSuccessor(Handler successor)
        {
            this.successor = successor;
        }
        public abstract void HandleRequest(int request);
    }

public class ConcreteHandler1 : Handler
    {
        public override void HandleRequest(int request)
        {
            if (request >= 0 && request < 10)
            {
                Console.WriteLine("{0} handled request {1}",
                    this.GetType().Name, request);
            }
            else if (successor != null)
            {
                successor.HandleRequest(request);
            }
        }
    }

public class ConcreteHandler2 : Handler
    {
        public override void HandleRequest(int request)
        {
            if (request >= 10)
            {
                Console.WriteLine("{0} handled request {1}",
                    this.GetType().Name, request);
            }
            else if (successor != null)
            {
                successor.HandleRequest(request);
            }
        }
    }

public static void Main(string[] args)
        {
            Handler h1 = new ConcreteHandler1();
            Handler h2 = new ConcreteHandler2();
            h1.SetSuccessor(h2);
            h2.SetSuccessor();

            int[] requests = { 2, 5, 14, 22, 18, 3, 27, 20 };

            foreach (int request in requests)
            {
                h1.HandleRequest(request);
            }
            Console.ReadKey();
        }

```

- **Command**: 
**Purpose:** The client's request (action, function and parameters) is delivered to the receiver as an object through an intermediary object. The goal is to abstract the client's request and the receiver's response from each other. 

**Example:** For example, let's say we have an Android TV. We can control this TV both from our Android-based mobile phone and from the TV remote control. For example, whether we press the button on the remote control or on the phone to turn up the volume, the same command, that is, the volume up command, runs on the TV side. It'll be a strange description, but let's imagine for a moment that this volume up hardware on the TV was made specifically for each person. In that case, there would be a strong dependency between turning up the volume and the people who would control it. With the remote control or the phone, the dependency is reduced, and the implementation is made easier with the volume up command offered by the television. Not every remote control has to mount the television's volume up technical infrastructure on itself. It's enough for it to just send the signal the television requests from the device to turn up the volume.

**How Is It Done?:** A command object is created that will take the object to be operated on as a parameter through its constructor. The command object also offers a function for the operation to be done on the related object. 

**Key Code Block:**

```c#
public interface ICommand
    {
        void Execute();
    }

public class OpenCommand : ICommand
    {
        private Document document;
        public OpenCommand(Document doc)
        {
            document = doc;
        }
        public void Execute()
        {
            document.Open();
        }

class SaveCommand : ICommand
    {
        private Document document;
        public SaveCommand(Document doc)
        {
            document = doc;
        }
        public void Execute()
        {
            document.Save();
        }
    }

class Program
    {
        static void Main(string[] args)
        {
            Document document = new Document();
            ICommand openCommand = new OpenCommand(document);
            ICommand saveCommand = new SaveCommand(document);

            openCommand.Execute();
            closeCommand.Execute();

            Console.ReadKey();
        }
    }

```

- **Interpreter**: 
**Purpose:** Used in situations where texts in a certain format need to be processed.

**Example:** It can be used in situations we also deal with in real life, like decoding roman numerals or decrypting an encrypted text.

**How Is It Done?:** First, a context object is created that will hold the data we'll work on. Then an expression interface is created, which the expression objects that will operate on the context object will implement. With the help of a function on this interface, the context object is taken as a parameter and the operations are done. More than one expression object can be created. 

**Key Code Block:** An example that formats today's date according to the user's format preference.


```c#
public class Context
    {
        public string expression { get; set; }
        public DateTime date { get; set; }
        public Context(DateTime date)
        {
            this.date = date;
        }
    }

public interface AbstractExpression
    {
        void Evaluate(Context context);
    }

public class DayExpression : AbstractExpression
    {
        public void Evaluate(Context context)
        {
            string expression = context.expression;
            context.expression = expression.Replace("DD", context.date.Day.ToString());
        }

public class MonthExpression : AbstractExpression
    {
        public void Evaluate(Context context)
        {
            string expression = context.expression;
            context.expression = expression.Replace("MM", context.date.Month.ToString());
        }
    }
public class YearExpression : AbstractExpression
    {
        public void Evaluate(Context context)
        {
            string expression = context.expression;
            context.expression = expression.Replace("YYYY", context.date.Year.ToString());
        }
    }
class SeparatorExpression : AbstractExpression
    {
        public void Evaluate(Context context)
        {
            string expression = context.expression;
            context.expression = expression.Replace(" ", "-");
        }
    }

 public class Program
    {
    static void Main(string[] args)
        {
            List<AbstractExpression> objExpressions = new List<AbstractExpression>();
            Context context = new Context(DateTime.Now);
            Console.WriteLine("Please select the Expression  : MM DD YYYY or YYYY MM DD or DD MM YYYY ");
            context.expression = Console.ReadLine();
            string[] strArray = context.expression.Split(' ');
            foreach(var item in strArray)
            {
                if(item == "DD")
                {
                    objExpressions.Add(new DayExpression());
                }
                else if (item == "MM")
                {
                    objExpressions.Add(new MonthExpression());
                }
                else if (item == "YYYY")
                {
                    objExpressions.Add(new YearExpression());
                }
            }
            objExpressions.Add(new SeparatorExpression());
            foreach(var obj in objExpressions)
            {
                obj.Evaluate(context);
            }
            Console.WriteLine(context.expression);
            Console.Read();
        }
    }


```


- **Iterator**: 
**Purpose:** Used to traverse the elements of a collection independently of their types.

**Example:** For example, a mail carrier or a courier visiting all the addresses on the list one by one and dropping off the packages could be an example. Who lives in the house, the shape of the house, etc. don't concern the mail carrier.

**How Is It Done?:**  Programming languages now come with many ready-made libraries for this. In many languages there are many iterable objects such as list, collection, enumerable, dictionary, array, etc. The design pattern is set up using these objects. First, the collection/array object is created. Then an iterator object is written that takes this object as a parameter and lets us traverse its elements.

**Key Code Block:**

```c#
class Elempoyee
    {
        public int ID { get; set; }
        public string Name { get; set; }
        public Elempoyee(string name, int id)
        {
            Name = name;
            ID = id;
        }
    }

interface IIterator
    {
         Elempoyee First();
         Elempoyee Next();
         bool IsCompleted { get; }
    }

class Iterator : IIterator
    {
        private ConcreteCollection collection;
        private int current = 0;
        private int step = 1;

        public Iterator(ConcreteCollection collection)
        {
            this.collection = collection;
        }

        public Elempoyee First()
        {
            current = 0;
            return collection.GetEmployee(current);
        }

        public Elempoyee Next()
        {
            current += step;
            if (!IsCompleted)
            {
                return collection.GetEmployee(current);
            }
            else
            {
                return null;
            }
        }

        public bool IsCompleted
        {
            get { return current >= collection.Count; }
        }
    }

interface ICollection
    {
        Iterator CreateIterator();
    }


class ConcreteCollection : ICollection
    {
        private List<Elempoyee> listEmployees = new List<Elempoyee>();

        public Iterator CreateIterator()
        {
            return new Iterator(this);
        }

        public int Count
        {
            get { return listEmployees.Count; }
        }

        public void AddEmployee(Elempoyee employee)
        {
            listEmployees.Add(employee);
        }

        public Elempoyee GetEmployee(int IndexPosition)
        {
            return listEmployees[IndexPosition];
        }
    }

public class Program
    {
        static void Main()
        {
            ConcreteCollection collection = new ConcreteCollection();
            collection.AddEmployee(new Elempoyee("Ahmet", 100));
            collection.AddEmployee(new Elempoyee("Mehmet", 101));
            collection.AddEmployee(new Elempoyee("Can", 102));

            
            Iterator iterator = collection.CreateIterator();

            Console.WriteLine("Iterating over collection:");
            
            for (Elempoyee emp = iterator.First(); !iterator.IsCompleted; emp = iterator.Next())
            {
                Console.WriteLine($"ID : {emp.ID} & Name : {emp.Name}");
            }
            Console.Read();
        }
    }


```

- **Mediator**: 
**Purpose:** Used to remove complex dependencies between objects doing similar work with loose coupling. Its meaning is a mediator anyway.


**Example:** For example, planes that want to land at an airport communicate with the tower, not with each other. Or people who want to buy or rent a house go to a real estate agent or a website instead of dealing with each other or with the sellers directly.

**How Is It Done?:**  First, the objects that will communicate with each other are defined. A mediator object is created that contains the list of these objects, or, even if there's no list, the definition of each object. The mediator object is passed as a parameter to the constructor of the objects that will communicate with each other. On the mediator object there's a function for communicating with the other objects. Since all objects take the mediator object as a parameter, they can communicate with each other. In the example below, the message sent goes to everyone.

**Key Code Block:**

```c#
    public interface IFacebookGroupMediator
    {
         void SendMessage(string msg, User user);
         void RegisterUser(User user);
    }

public class ConcreteFacebookGroupMediator : IFacebookGroupMediator
    {
        private List<User> usersList = new List<User>();
        public void RegisterUser(User user)
        {
            usersList.Add(user);
        }
        public void SendMessage(string message, User user)
        {
            foreach (var u in usersList)
            {
                if (u != user)
                {
                    u.Receive(message);
                }
            }
        }
    }

public abstract class User
    {
        protected IFacebookGroupMediator mediator;
        protected string name;
        public User(IFacebookGroupMediator mediator, string name)
        {
            this.mediator = mediator;
            this.name = name;
        }
        public abstract void Send(string message);
        public abstract void Receive(string message);
    }

public class ConcreteUser : User
    {
        public ConcreteUser(IFacebookGroupMediator mediator, string name) : base(mediator, name)
        {
        }
        public override void Receive(string message)
        {
            Console.WriteLine(this.name + ": Received Message:" + message);
        }
        public override void Send(string message)
        {
            Console.WriteLine(this.name + ": Sending Message=" + message + "\n");
            mediator.SendMessage(message, this);
        }
    }


class Program
    {
        static void Main(string[] args)
        {
            IFacebookGroupMediator facebookMediator = new ConcreteFacebookGroupMediator();
            User Murat = new ConcreteUser(facebookMediator, "Murat");
            User Mehmet = new ConcreteUser(facebookMediator, "Mehmet");
            User Ali = new ConcreteUser(facebookMediator, "Ali");
            User Zeynep = new ConcreteUser(facebookMediator, "Zeynep");
            User Ayse = new ConcreteUser(facebookMediator, "Ayşe");
            User Can = new ConcreteUser(facebookMediator, "Can");
            User Jale = new ConcreteUser(facebookMediator, "Jale");
            User Ziya = new ConcreteUser(facebookMediator, "Ziya");
            facebookMediator.RegisterUser(Murat);
            facebookMediator.RegisterUser(Mehmet);
            facebookMediator.RegisterUser(Ali);
            facebookMediator.RegisterUser(Zeynep);
            facebookMediator.RegisterUser(Ayse);
            facebookMediator.RegisterUser(Can);
            facebookMediator.RegisterUser(Jale);
            facebookMediator.RegisterUser(Ziya);
            Mehmet.Send("Hello Friends");
            Console.WriteLine();
            Zeynep.Send("Hello Murat");
            Console.Read();
        }
    }

```

- **Memento**: 
**Purpose:** Used to make it possible to go back to an object's previous state while hiding its internal structure and implementation details. 

**Example:** There's no need to give a direct real-life example. All situations where an object is taken back to its old state are examples of this design pattern. 
 
**How Is It Done?:** A memento object is written to store the state of our main object (originator). In the memento object, the state of our real object is taken as a parameter through the constructor. The Originator (main object) creates the memento object by giving its own state. But another object is used to store this state (Caretaker).

**Key Code Block:**  In the code below, the SalesProspect object is the originator, and the ProspectMemory object is the Caretaker object.

```c#

public class Program
    {
        public static void Main(string[] args)
        {
            SalesProspect s = new SalesProspect();
            s.Name = "Noel van Halen";
            s.Phone = "(412) 256-0990";
            s.Budget = 25000.0;

            ProspectMemory m = new ProspectMemory();
            m.Memento = s.SaveMemento();

            s.Name = "Leo Welch";
            s.Phone = "(310) 209-7111";
            s.Budget = 1000000.0;

            s.RestoreMemento(m.Memento);

            Console.ReadKey();
        }
    }
    public class SalesProspect
    {
        public string Name {get;set;}

        public string Phone {get;set;}

        public double Budget {get;set;}


        public Memento SaveMemento()
        {
            Console.WriteLine("\nSaving state --\n");
            return new Memento(Name, Phone, Budget);
        }

        public void RestoreMemento(Memento memento)
        {
            Console.WriteLine("\nRestoring state --\n");
            Name = memento.Name;
            Phone = memento.Phone;
            Budget = memento.Budget;
        }
    }

    public class Memento
    {
        public Memento(string name, string phone, double budget)
        {
            this.Name = name;
            this.Phone = phone;
            this.Budget = budget;
        }
        public string Name{get; set; }
        public string Phone{get; set; }
        public double Budget{get; set; }
    }

    public class ProspectMemory
    {
        public Memento Memento {get;set;}
    }
```

- **Observer**: 

**Purpose:** Used to announce the changes that occur in an object to the objects that want to be informed about them.

**Example:** For example, you subscribed to a magazine, and your goal is to make sure the magazine reaches you when it comes out. Or wanting the website or application to send you an sms when there's a discount on a certain product could be given as an example.

**How Is It Done?:**  First, the object that will be watched by the other objects is created. On this object there's a list of the objects that will watch it, that is, the observers, and a function to add elements to this list. Observer objects implement the same interface and offer a function for the change that occurs in the watched object to be passed on.  

**Key Code Block:**

```c#
public interface ISubject
    {
         void RegisterObserver(IObserver observer);
         void RemoveObserver(IObserver observer);
         void NotifyObservers();
    }
public class Subject : ISubject
    {
        private List<IObserver> observers = new List<IObserver>();
        private string ProductName { get; set; }
        private int ProductPrice { get; set; }
        private string Availability { get; set; }
        public Subject(string productName, int productPrice, string availability)
        {
            ProductName = productName;
            ProductPrice = productPrice;
            Availability = availability;
        }
        
        public string getAvailability()
        {
            return Availability;
        }
        public void setAvailability(string availability)
        {
            this.Availability = availability;
            Console.WriteLine("The availability status of the product has changed.");
            NotifyObservers();
        }
        public void RegisterObserver(IObserver observer)
        {
            Console.WriteLine("New Observer Added: " + ((Observer)observer).UserName );
            observers.Add(observer);
        }
        public void AddObservers(IObserver observer)
        {
            observers.Add(observer);
        }
        public void RemoveObserver(IObserver observer)
        {
            observers.Remove(observer);
        }
        public void NotifyObservers()
        {
            Console.WriteLine("Product Name :"
                            + ProductName + ", Product Price : "
                            + ProductPrice + " is now ready for sale. You can notify all registered users.");
            Console.WriteLine();
            foreach (IObserver observer in observers)
            {
                observer.update(Availability);
            }
        }
    }
public interface IObserver
    {
        void update(string availability);
    }
public class Observer : IObserver
    {
        public string UserName { get; set; }
        public Observer(string userName, ISubject subject)
        {
            UserName = userName;
            subject.RegisterObserver(this);
        }
        
        public void update(string availabiliy)
        {
            Console.WriteLine("Hello " + UserName + ", the availability status of the product on Amazon: " + availabiliy);
        }


class Program
    {
        static void Main(string[] args)
        {
            // save the product as out of stock.
            Subject RedMI = new Subject("Red MI Mobile", 10000, "Out Of Stock");

            //add the user Murat to the follower list of the RedMI product
            Observer user1 = new Observer("Murat", RedMI);

            //add the user Can to the follower list of the RedMI product
            Observer user2 = new Observer("Can", RedMI);

            //add the user Jale to the follower list of the RedMI product
            Observer user3 = new Observer("Jale", RedMI);
            
            Console.WriteLine("Current status of the Red MI product : " + RedMI.getAvailability());
            Console.WriteLine();
            // The product is now ready for sale
            RedMI.setAvailability("Available");
            Console.Read();
        }
    }



```
- **State**: 
**Purpose:** Used to make an object's behavior change when its internal state changes.

**Example:** For example, in real life, when there's an abnormal expense on our credit card, if the bank puts our card into a locked state, our card no longer lets us make purchases. When the same card's state switches to safe, the credit card becomes usable again. 

**How Is It Done?:**  An object is designed for each state. In these state objects, functions are defined for all the work to be done while in the related state. In other words, the work to be done while in state A and the work to be done in state B are exactly the same, but, that is, the work to be done in each state has a counterpart, and as a result they all implement the same interface. Then we define our real object, that is, the object we'll work on, with a constructor that will take the state interface as a parameter, or with a public variable.

**Key Code Block:** 

```c#

public interface IState
    {
        Account account;
        double balance;
        double interest;
        double lowerLimit;
        double upperLimit;
        // Properties
        Account Account
        {
            get { return account; }
            set { account = value; }
        }
        double Balance
        {
            get { return balance; }
            set { balance = value; }
        }
        void Deposit(double amount);
        void Withdraw(double amount);
        void PayInterest();
    }

public class RedState : IState
    {
        private double serviceFee;
        public RedState(State state)
        {
            this.balance = state.Balance;
            this.account = state.Account;
            Initialize();
        }
        private void Initialize()
        {
            interest = 0.0;
            lowerLimit = -100.0;
            upperLimit = 0.0;
            serviceFee = 15.00;
        }
        public void Deposit(double amount)
        {
            balance += amount;
            StateChangeCheck();
        }
        public void Withdraw(double amount)
        {
            amount = amount - serviceFee;
            Console.WriteLine("No funds available for withdrawal!");
        }
        public  void PayInterest()
        {

        }
        private void StateChangeCheck()
        {
            if (balance > upperLimit)
            {
                account.State = new SilverState(this);
            }
        }
    }

public class SilverState : IState
    {
        public SilverState(State state) :
            this(state.Balance, state.Account)
        {
        }
        public SilverState(double balance, Account account)
        {
            this.balance = balance;
            this.account = account;
            Initialize();
        }
        private void Initialize()
        {
            interest = 0.0;
            lowerLimit = 0.0;
            upperLimit = 1000.0;
        }
        public void Deposit(double amount)
        {
            balance += amount;
            StateChangeCheck();
        }
        public void Withdraw(double amount)
        {
            balance -= amount;
            StateChangeCheck();
        }
        public void PayInterest()
        {
            balance += interest * balance;
            StateChangeCheck();
        }
        private void StateChangeCheck()
        {
            if (balance < lowerLimit)
            {
                account.State = new RedState(this);
            }
            else if (balance > upperLimit)
            {
                account.State = new GoldState(this);
            }
        }
    }

public class GoldState : State
    {
        public GoldState(State state)
            : this(state.Balance, state.Account)
        {
        }
        public GoldState(double balance, Account account)
        {
            this.balance = balance;
            this.account = account;
            Initialize();
        }
        private void Initialize()
        {
            interest = 0.05;
            lowerLimit = 1000.0;
            upperLimit = 10000000.0;
        }
        public override void Deposit(double amount)
        {
            balance += amount;
            StateChangeCheck();
        }
        public override void Withdraw(double amount)
        {
            balance -= amount;
            StateChangeCheck();
        }
        public override void PayInterest()
        {
            balance += interest * balance;
            StateChangeCheck();
        }
        private void StateChangeCheck()
        {
            if (balance < 0.0)
            {
                account.State = new RedState(this);
            }
            else if (balance < lowerLimit)
            {
                account.State = new SilverState(this);
            }
        }
    }

public class Account
    {
        private IState state;
        private string owner;

        public Account(string owner)
        {
            this.owner = owner;
            this.state = new SilverState(0.0, this);
        }
        public double Balance
        {
            get { return state.Balance; }
        }
        public State State
        {
            get { return state; }
            set { state = value; }
        }
        public void Deposit(double amount)
        {
            state.Deposit(amount);
            Console.WriteLine("{0:C} --- deposited ", amount);
            Console.WriteLine(" Balance in Your Account = {0:C}", this.Balance);
            Console.WriteLine(" Status  = {0}",
                this.State.GetType().Name);
            Console.WriteLine("");
        }
        public void Withdraw(double amount)
        {
            state.Withdraw(amount);
            Console.WriteLine("{0:C} --- withdrawn, ", amount);
            Console.WriteLine(" Balance in Your Account = {0:C}", this.Balance);
            Console.WriteLine(" Status  = {0}\n",
                this.State.GetType().Name);
        }
        public void PayInterest()
        {
            state.PayInterest();
            Console.WriteLine(" Interest Paid --- ");
            Console.WriteLine(" Balance in Your Account = {0:C}", this.Balance);
            Console.WriteLine(" Durum  = {0}\n",
                this.State.GetType().Name);
        }
    }

```
- **Strategy**: 

**Purpose:** Used to be able to choose, at runtime, one of a group of algorithms that do the same job.

**Example:** To make it memorable, rather than giving a direct example for this, I'd like to say this: think of the moments in your life when, although there was more than one way to do something, you chose one of them. In some cases, you may have even chosen a different way for the same job at different times.

**How Is It Done?:**  Strategy objects that do the same job in different ways are created so that they all implement the same interface. Then we create our object that will use these objects. This object takes the interface we implemented the strategy objects with as a parameter through its constructor.

**Key Code Block:**

```c#
public interface ISortStrategy
    {
        void Sort(List<string> list);
    }

    public class QuickSort : ISortStrategy
    {
        public  void Sort(List<string> list)
        {
            list.Sort(); 
            Console.WriteLine("QuickSorted list ");
        }
    }

    public class ShellSort : ISortStrategy
    {
        public  void Sort(List<string> list)
        {

            Console.WriteLine("ShellSorted list ");
        }
    }

    public class MergeSort : ISortStrategy
    {
        public  void Sort(List<string> list)
        {

            Console.WriteLine("MergeSorted list ");
        }
    }

    public class SortedList
    {
        private List<string> list = new List<string>();
        private ISortStrategy sortstrategy;
        public void SetSortStrategy(ISortStrategy sortstrategy)
        {
            this.sortstrategy = sortstrategy;
        }
        public void Add(string name)
        {
            list.Add(name);
        }
        public void Sort()
        {
            sortstrategy.Sort(list);


            foreach (string name in list)
            {
                Console.WriteLine(" " + name);
            }
            Console.WriteLine();
        }
    }

public class Program
    {
        public static void Main(string[] args)
        {
            SortedList studentRecords = new SortedList();
            studentRecords.Add("Ayşe");
            studentRecords.Add("Ahmet");
            studentRecords.Add("Selim");
            studentRecords.Add("Caner");
            studentRecords.Add("Jale");
            studentRecords.SetSortStrategy(new QuickSort());
            studentRecords.Sort();
            studentRecords.SetSortStrategy(new ShellSort());
            studentRecords.Sort();
            studentRecords.SetSortStrategy(new MergeSort());
            studentRecords.Sort();


            Console.ReadKey();
        }
    }



```

- **Template Method**: 

**Purpose:** Used both to determine the order/arrangement of a series of tasks that need to be done in a certain order/arrangement, and to allow some of these tasks to be done by subclasses.

**Example:** For a construction project to be done, all the tasks need to be completed in order. Contractors have to do the job they took on in accordance with certain procedures and their order. But they can also do some tasks their own way, to the extent the procedures allow. So different contractors can do the same job in different ways. Even if the basic procedures are the same, there will be many things they'll do differently.

**How Is It Done?:**  Usually an abstract class is defined for the basic work. Not all functions inside this class have to do work. Some work is allowed to be done (overridden) by subclasses. Subclasses inherit this abstract class and override the methods they want.

**Key Code Block:**

```c#



    public abstract class DataAccessor
    {
        public abstract void Connect();
        public abstract void Select();
        public abstract void Process(int top);
        public abstract void Disconnect();

        public void Run(int top)
        {
            Connect();
            Select();
            Process(top);
            Disconnect();
        }
    }

    public class Categories : DataAccessor
    {
        private List<string> categories;
        public override void Connect()
        {
            categories = new List<string>();
        }
        public override void Select()
        {
            categories.Add("Red");
            categories.Add("Green");
            categories.Add("Blue");
            categories.Add("Yellow");
            categories.Add("Purple");
            categories.Add("White");
            categories.Add("Black");
        }
        public override void Process(int top)
        {
            Console.WriteLine("Categories ---- ");
            for(int i = 0; i < top; i++)
            {
                Console.WriteLine(categories[i]);
            }
            
            Console.WriteLine();
        }
        public override void Disconnect()
        {
            categories.Clear();
        }
    }

    public class Products : DataAccessor
    {
        private List<string> products;
        public override void Connect()
        {
            products = new List<string>();
        }
        public override void Select()
        {
            products.Add("Car");
            products.Add("Bike");
            products.Add("Boat");
            products.Add("Truck");
            products.Add("Moped");
            products.Add("Rollerskate");
            products.Add("Stroller");
        }
        public override void Process(int top)
        {
            Console.WriteLine("Products ---- ");
            for (int i = 0; i < top; i++)
            {
                Console.WriteLine(products[i]);
            }
            Console.WriteLine();
        }
        public override void Disconnect()
        {
            products.Clear();
        }
    }


    public class Program
    {
        public static void Main(string[] args)
        {
            DataAccessor categories = new Categories();
            categories.Run(5);
            DataAccessor products = new Products();
            products.Run(3);

            Console.ReadKey();
        }
    }

```
- **Visitor**: 

**Purpose:** It's the design pattern that lets us run new operations on an object without changing the object.

**Example:** For example, let's imagine a doctor coming to a school to give vaccinations. Normally, the school doesn't have a service like vaccinating its students, meaning it's not one of its core jobs. The doctor who will give the vaccines comes to the school as a guest and vaccinates the students at the school. There's no need to make any change in the school's structure (for example, changing its organization chart) or in the students (for example, having them wear different clothes because they'll be vaccinated). 

**How Is It Done?:**  One or more visitor objects implementing the same interface are created. Methods are added to these visitor objects for the work to be done. Then we define our object/objects that we'll actually operate on so that they take our visitor interface as a parameter through the constructor.

**Key Code Block:** The salary and leave definitions for each employee are done with the visitor object.

```c#

public interface IVisitor
    {
        void Visit(Element element);
    }

public class IncomeVisitor : IVisitor
    {
        public void Visit(Element element)
        {
            Employee employee = element as Employee;

            employee.Income *= 1.10;
            Console.WriteLine("{0} {1}'s new income: {2:C}",
                employee.GetType().Name, employee.Name,
                employee.Income);
        }
    }

public class VacationVisitor : IVisitor
    {
        public void Visit(IElement element)
        {
            Employee employee = element as Employee;

            employee.VacationDays += 3;
            Console.WriteLine("{0} {1}'s new vacation days: {2}",
                employee.GetType().Name, employee.Name,
                employee.VacationDays);
        }
    }

public interface IElement
    {
        void Accept(IVisitor visitor);
    }


public class Employee : IElement
    {

        public Employee(string name, double income,
            int vacationDays)
        {
            this.Name = name;
            this.Income = income;
            this.VacationDays = vacationDays;
        }
        public string Name {get;set;}

        public double Income {get;set;}

        public int VacationDays {get;set;}

        public void Accept(IVisitor visitor)
        {
            visitor.Visit(this);
        }
    }

public class Clerk : Employee
    {
        public Clerk()
            : base("Kevin", 25000.0, 14)
        {
        }
    }
public class Director : Employee
    {
        public Director()
            : base("Elly", 35000.0, 16)
        {
        }
    }
public class President : Employee
    {
        public President()
            : base("Eric", 45000.0, 21)
        {
        }
    }

public class Employees
    {
        private List<Employee> employees = new List<Employee>();
        public void Attach(Employee employee)
        {
            employees.Add(employee);
        }
        public void Detach(Employee employee)
        {
            employees.Remove(employee);
        }
        public void Accept(IVisitor visitor)
        {
            foreach (Employee employee in employees)
            {
                employee.Accept(visitor);
            }
            Console.WriteLine();
        }
    }


public class Program
    {
        public static void Main(string[] args)
        {
            Employees employee = new Employees();
            employee.Attach(new Clerk());
            employee.Attach(new Director());
            employee.Attach(new President());
            employee.Accept(new IncomeVisitor());
            employee.Accept(new VacationVisitor());
            Console.ReadKey();
        }
    }

```


Hope you found it useful.

In the next article, we'll touch on the relationships of design patterns with each other, and the places where they're similar and where they differ.


# Resources
- https://egitimbilimlerinotlari.com/bilgi-isleme-kuraminin-temel-kavramlari/
- https://tr.wikipedia.org/wiki/Loci_Metodu
- https://ogrencikariyeri.com/haber/verimli-ders-calismanin-en-etkili-yontemleri
- https://hackernoon.com/how-to-remember-design-patterns-ap1z35sl
- https://www.codeproject.com/tips/57578/the-best-way-to-remember-design-patterns
- https://en.wikipedia.org/wiki/Design_Patterns
- https://dotnettutorials.net/course/dot-net-design-patterns/
- https://refactoring.guru/design-patterns
- https://www.dofactory.com/
