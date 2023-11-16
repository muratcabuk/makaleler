# Tasarım Desenleri Nasıl Yazılır? (Tasarım Desenleri 1)

Merhaba arkadaşlar,

Bir önceki yazımızda tasarım desenlerini öğrenmeye çalışırken ne tür hatalar yaptığımızdan ve ve daha kalıcı olması için uygulanabilecek tekniklerden bahsetmiştik. Bu yazımızda da kaldığımız yerden devam ediyoruz. Amacımız bir iki cümle ile bir tasarım desenin nasıl inşa edileceğini anlatabilmek. Böylece ayrıntılardan arındırılmış bir anlatımla akılda daha kalı olmasını da sağlamış olacağız.

Bir sonraki yazımızda tasarım desenlerinin yapısal ve amaçsal ortak olduğu veya birbirlerinden ayrıştığı noktalara değineceğiz. İnceleyeceğimiz her bir tasarım deseninde diğer pattern'lerle olan ilişkilerine değineceğimiz için en azında her birinin amacı nedir ve nasıl yazılır sorularına kısa cevaplar verebilmek işimizi baya kolaylaştıracak.


Şimdi bir önceki yazımızda kaldığımız noktaya eklemeler yaparak devam edelim.

### Oluşturucu (Creational) Tasarım Desenleri


Nesneleri doğrudan somutlaştırmak yerine nesneler yaratan kalıplardır. Bu, belirli bir durum için hangi nesnelerin oluşturulması gerektiğine karar vermede programa daha fazla esneklik sağlar.

- **Singleton**: 
  
**Amaç:** Bir sınıf için nesne oluşturmayı bir instance (örnek) ile kısıtlar. Biraz daha farklı bir anlatımla tek bir nesnenin ona ihtiyaç olan bütün nesnelerce kullanılmasını sağlar. 
  
**Örnek:** Örneğin evdeki buzdolabını evdeki bütün bireylerin kullanması veya bir çöp konteynerini sokaktaki bir grup komşunun beraber kullanması gibi. Kodlama yaparken de bu tarz bir nesneye ihtiyaç duyduğumuzda bunu garantileyecek tasarım deseni singleton'dur.

**Nasıl Yapılır**: ilk condition'da nesneye ihtiyaç duyan bütün istekler için nesnenin create olup olmadığı kontrol edilir. Eğer nesne instance'ı henüz yoksa bir nesne üzerine lock statement yazılarak bu statement içine birden fazla request girmesi ihtimaline karşı ikinci bir condition konulur ve instance halen oluşmadıysa oluşturulur. lock içinde işini bitiren istekler lock statement'dan çıktıkça gelen her istek nesnenin oluşturulduğunu gördüğü için nesne tekrar create edilmemiş olacak. 

**Anahtar Kod Bloğu**

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
  
**Amaç:** Aynı interface'den türetilmiş farklı sınıflardan instance (örnek) oluşturmak için kullanılır. Tek bir metottur. 
  
**Örnek:** Örneğin aynı araba markasına sahip farklı modeller üretilmesini sağlayan bir fabrika düşünelim.

**Nasıl Yapılır?:** Oluşturulacak bütün nesneler aynı interface'den türetilir. Daha sonra yine bir interface'den türetilen fabrika nesnesi içindeki bir metot ile ilgili nesne oluşturulur.

**Anahtar Kod Bloğu**

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

**Amaç:** Birbiriyle ilişkili ancak birbirinden farklı bir grup nesneyi oluşturur. Bir sınıftır, birden fazla factory metottan meydana gelir. Hatta bazen birden fazla factory sınıfından meydana gelebilir.

**Örnek:** Örneğin farklı araba markalarına ait farklı modellerin üretildiği bir fabrika düşünelim. Hatta üçüncü bir boyut bile eklenebilir mesela farklı ülkeler için farklı markaların farklı modellerini üretmek için farklı farklı fabrikalar kullanılması gibi.

**Nasıl Yapılır?:** Oluşturulacak bütün nesneler aynı interface'den türetilir. Daha sonra yine bir interface'den türetilen fabrika nesnesi içindeki birden fazla metot ile ilgili nesneler oluşturulur. Hatta birden fazla fabrika üretmek istenirse fabrika nesnesinden daha fazla da üretilebilir.

**Anahtar Kod Bloğu**

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

**Amaç:** Karmaşık bir nesnenin oluşturulma süreci/adımları ile sunumunu birbirinden ayırarak aynı nesnenin farklı türlerinin oluşturulmasını sağlar. 

**Örnek:** Bir araba almak istediğimizde galeriye gideriz. Hangi özellikleri istediğimizi söyleriz ve belli bir süre sonra istediğimiz araç fabrikada üretilir ve teslim edilir. Haliyle üretim süreci karmaşıktır, bir çok iş sırayla ve belirli süreçler takip edilerek tamamlanır. Aracın yapımı ve süreçleri fabrikada yapılırken sunumu ve satışı galeri tarafından yapılır.

**Nasıl Yapılır?:** En basit haliyle bir veya birden fazla builder nesnesi ile ilgili nesnelerin parçaları farklı fonksiyonlara oluşturulacak şekilde yazılır. Daha sonra bir director nesnesi ile bir veya birden fazla builder nesnesi ilgili nesneyi oluşturacak fonksiyona parameter olarak geçirilir.

**Anahtar Kod Bloğu**

Tek bir nesnenin oluşturulmasına örnek

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

**Amaç:** Oluşturulması çok maliyetli olan nesnelerin daha önce oluşturulmuş benzer örneklerinden klonlama/kopyalama yapılmasını sağlar.

**Örnek:** Çilingire anahtar kopyalamaya gittiğimize bir an için çilingirin kopyası oluşturulacak anahtarın gireceği kapı anahtar göbeğini istediğini ve içini açıp milim milim uzunlukları ölçtüğünü, anahtarın dişlerinin açılarını hesapladığını ve bu hesaba göre bize anahtarı ürettiğini hayal edelim. Bu şuan kopyalamayı bildiğimiz için ne kadar gereksiz geliyor değil mi? 

Bir satırlık kod ile kolaylıkla oluşturduğumuz bazı nesnelerin sistem tarafından ne kadar cpu,memory ve network kullanılarak üretildiğini düşünürsek bu hatayı ne kadar çok yaptığımızı anlayabiliriz. Biz kod yazmadığımız için sanki o kadar iş yokmuş gibi geliyor olabilir. Ancak  performansın önemli olduğu çok kullanıcılı bir uygulamada bir  nesnenin sistemi ve network'ü yoğun kullanarak oluşturulması ciddi problemlere sebep olabilir.

**Nasıl Yapılır?:** Kopyası alınacak nesne içine kopyalama fonksiyonu tanımlanır ve nesnenin kopyası döndürülür.

**Anahtar Kod Bloğu**


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



### Yapısal (Structural) Tasarım Desenleri

- **Adapter**: 

**Amaç:** İki farklı interface'in birlikte çalışabilmesini sağlar. 

**Örnek:** Gerçek hayatta kullandığımız adaptörler tam olarak aynı işi yapmaktadır. Amerika'dan aldığımız bir elektronik cihazın fişini Türkiye'deki prizlere uygun hale getirmek için kullandığımız adaptörler buna örnektir.

**Nasıl Yapılır?:** Gerçek hayatta kullandığımız adaptörler gibi ara bir nesne oluşturulur ve kaynak nesne adapter nesnesine parametre olarak geçilir. Alınan kaynak nesneden istemcinin beklediği veriler değiştirilerek sunulur. 

**Anahtar Kod Bloğu**

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

**Amaç:** Nesnenin soyutlaması ile implementasyonunu birbirinden ayırmak için kullanılır. Böylece ikisi birbirinden bağımsız genişleyebilir.

**Örnek:** Gerçek hayat örneğini vermek biraz zor ancak yine teşbihte hata olmaz deyip örneklendirmeye çalışalım. Örneğin araba üretiyor olalım. Arabaları tüm müşterilerin isteklerini karşılayacak şekilde üretmemiz imkansız olacaktır. Onun yerine arabaları elimizdeki teknik dokümanlara göre (abstraction) temelde sahip olması gereken tüm parçaları ile üretip müşteriden müşteriye değişim gösteren özellikleri satın alma esnasında müşterilerimizden alıp üretimin tamamlanmasını sağlamak daha az maliyetli olacaktır. Örneğin rengi, sunroof olup olmaması gibi.

**Nasıl Yapılır?:** İki parçadan oluşuyor abstraction ve implementation. İstemcinin talep ettiği değerin bir kısmı değişmeyen kısım (abstraction) diğer kısmı ise değiştirilebilen yani isteğe göre seçilebilen kısım (implementation). Mesela biz bir şekil çizen kod yazabiliriz ancak istemciye renk seçimi yaptırmamız gerekebilir. Bunun için öncelikle abstraction kısmı yazılır ve değişen kısım parametre olarak abstraction nesnesine geçilir. 

**Anahtar Kod Bloğu**

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

**Amaç:** Ortak arayüze sahip nesneler arasında parent-child (tree) ilişkisi kurulabiliyorsa istemciyi parçalardan soyutlayıp tek bir nesne ile muhatap kılmak için kullanılır.

**Örnek:** Amaç nesnelerin tree yapısında tek bir bileşik nesne olarak oluşturmaktır. Şuan tabii ki bu tarz kütüphaneler artık dillerde mevcut ancak kitabın yazıldığı tarihleri düşünecek olursak pattern olarak anlatılmaya çalışılması mantıklı görünüyor. Örneğin bir galeriye gittiniz ve bir aracın fiyatını sordunuz ve satıcı size bütün parçaların fiyatını tek tek hesaplamaya başladı. Bu çok anlamsız olur haliyle. Tabii ki bir aracın fiyatını hesaplamak için bütün parçaların fiyatı tek tek bilinmeli ancak bu alıcı olarak bizi ilgilendirmiyor.

**Nasıl Yapılır?:** Hiyerarşik yapıdaki bütün elementlere aynı interface uygulanır. Her bir element child elementlerinin listesini veya tek bir child elemanın bilgisini tutar.


**Anahtar Kod Bloğu**:


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

**Amaç:** Dinamik olarak bir nesneye yeni sorumluluklar eklemek veya değiştirmek için kullanılır.

**Örnek:** Tam bir örnek olamayabilir ama akılda kalıcı olacağını düşünüyorum. Mesela benzinli aracımıza LPG taktırmak buna örnek olabilir.  

**Nasıl Yapılır?:**  Dekore edilecek nesne ile aynı interface'i implement eden  decorator sınıfına nesnenin kendisi parametere olarak geçilir.

**Anahtar Kod Bloğu:**

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
**Amaç:** Çok karmaşık sistemleri kullanabilmek amacıyla daha basitleştirilmiş bir arayüz sunmak için kullanılır.

**Örnek:**Örneğin bir aracı kullanırken direksiyonun arkasında neler döndüğünü bilmeyiz. Yada bilgisayar kullanırken tek bildiğimiz klavye, mouse ve monitördür geri kalan detayları bilmemize gerek yoktur.

**Nasıl Yapılır?:**  Class içinde bir fonksiyon yardımıyla diğer nesnelerdeki fonksiyonlar sırasıyla çağrılır. 

**Anahtar Kod Bloğu:** Örneğin farklı subsystem'lerden foksiyonlar çağrılarak bir başka system kurulabilir. Örneğin fatura kesmek için ürün detaylarına, alıcı bilgilerine veya ödeme yapılıp yapılmadığı bilgisine ihtiyacımız olacak. Bu bilgileri kullanarak da fatura kesmiş oluyoruz. 

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

**Amaç:** Tek başına küçük olmasına rağmen yüzlerce oluşturulduğunda çok maliyetli olacak nesnelerin oluşturulmasında kullanılır.

**Örnek:**İllaki nesneleri o kadar sayıda oluşturmaya gerek olmayabilir, acaba başka bir yolu yok mudur bu işin mantığı ile çözüm üretilir. Örneğin bir araç kiralama firması muhtemel farklı bin müşteri için bin adet araç satın alamaz. Onun yerine yüz aracı farklı zamanlarda onlara kiralar. Yani bin müşterinin işi görülür fakat bu yüz araçla yapılır. Aracın hangi tarihte kime ait olacağı gibi özellik aracın iç özelliklerinden değildir sadece bir durumdur onu değiştirerek aynı hizmet verilir.

**Nasıl Yapılır?:**  Öncelikle nesneyi oluşturmak için ilgili nesneyi ifade eden bir interface veya abstract class yazılır. Bu interface client tarafında değiştirebilecek kısımlar için fonksiyon sunar. Genellikle bu nesneler bir factory yardımıyla oluşturulur ve belli sayıda (list, array, dictionary vb objelerde) saklanır. Nesneye ihtiyaç olduğunda listeden okunarak kullanıma sunulur. İşi biten nesne tekrar listeye eklenir. Aynı anda aynı nesnenin listedeki tüm örneklerine ihtiyaç olmadığı sürece sorun olmayacaktır.

**Anahtar Kod Bloğu:**  SetColor fonksiyonu ile istemci tarafından nesnenin rengi değiştirilebiliyor.

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
**Amaç:** Gerçek nesnenin yerine geçerek istemci tarafında hiç bir değişiklik yaptırtmadan gerçek nesnenin ya hiç yapamadığı yada eksik yaptığı bazı işleri yapmak için kullanılır.

**Örnek:** Loglama, cache'leme, güvenlik, performans gibi işler için kullanılabilir. Gerçek hayattan en iyi örnek avukatlar olabilir. Bizim adımıza bizim yapamadığımız veya çok iyi yapamayacağımız bir davada savunma işini bizim adımıza yapabilirler. Yada noterden vekalet verdiğimizde de bi sebepten dolayı yapamayacağımız bir işi bir başkasına yaptırabiliyoruz.Yada mesela banka kartımızla bankadan para çekebileceğimiz gibi bankamatikten de para çekebiliriz. 

**Nasıl Yapılır?:**  Oluşturulacak nesne ile aynı interface'i implement eden proxy nesnesi yazılır. İhtiyaca göre client tarafında hiçbir değişikliğe gerek kalmayacak şekilde proxy sınıfında ekleme ve düzenlemeler yapılır. 

**Anahtar Kod Bloğu:** Dikkat edilirse DisplayImage fonksiyonu asıl nesnede de proxy nesnesinde de var. DisplayImage fonksiyonu içinde asıl fonksiyon çalışmadan önce ve sonra farklı işlemler de yapılabilir. Mesela resim cache'den getirilebilir yada resmin çağıran kullanıcı ve tarih loglanabilir.

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
### Davranışsal Tasarım Desenleri

- **Chain of Responsibility**: 
**Amaç:** Bir nesne üzerinde yapılması gereken bir dizi işlemi istemcinin kendi kararı ile nesneyi ilgili sorumluluğu yapabilecek nesnelere geçirerek tamamlamayı sağlar.

**Örnek:** Devlet dairelerine gittiğimizde sırasıyla bazı işleri yapmamamız gerekir. Elimizdeki bir belgede sırasıyla yapılması gereken bazı işler olur ve bunlara göre bazı ofisler gezilerek o ofisin yapması gereken işler yaptırılıp diğer ofise geçilir. Son tahlilde bütün işler bittiğinde  her ofisin onay imzası ile işimiz bitmiş olur. Örneğin bir bankadan para çekmek istediniz yada bir kredi başvurunda bulunacaksınız. Bu başvuruyu yada para çekme işlemini başlattığınızda bir dizi işlem arka arkaya belli bir sıra ile yapılır. 

**Nasıl Yapılır?:**  Builder'a çok benzer görünmesine rağmen en temel fark orada sadece nesne yaratma amacı varken burada herhangi bir işi tamamlama amacı vardır. Aynı interface'i implement eden bir dizi nesne oluşturulur. Her bir nesne zincirin bir halkası gibidir. Implement edilen interface üzerinde bir sonraki adımı parametre olarak isteyen bir fonksiyon bulunur. Bir sonraki adım da aynı interface'den implement edilmek zorundadır bu nedenle parametre olarak interface'in kendisi verilir. Ayrıca bu interface'de üzerinde işlem yapılacak veya verileri kullanılacak nesneyi parametre olarak alan ve gerekli işlemleri de yapan başka bir fonksiyon bulunur. Bu fonksiyon işi yaptıktan sonra bir sonraki adımı ifade eden nesne üzerindeki aynı adlı fonksiyona parametre olarak aldığı nesneyi parametre olarak geçer. Alttaki örnekteki gibi interface yerine abstract class kullanmak da mümkündür.

**Anahtar Kod Bloğu:** 

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
**Amaç:** İstemcinin talebini(action, function ve parametreler) bir nesne olarak aracı nesne üzerinden alıcıya ulaştırılır. Amaç istemcinin talebi ile alıcının cevabını birbirinden soyutlamaktır. 

**Örnek:** Örneğin bir Android TV'miz olsun. Bu televizyonu hem Android tabanlı cep telefonumuzdan veya TV uzaktan kumandasından yönetebiliriz. Örneğin sesi açmak için uzaktan kumandadan düğmeye bastığımızda da, telefon üzerinden bastığımızda da TV tarafında aynı komut yani ses açma komutu çalışmış oluyor. Garip  bir tanımlama olacak ama bir an için TV üzerindeki bu ses açma donanımının her kişiye özel olarak yapıldığını hayal edelim. Bu durumda ses açma ile bunu kontrol edecek insanlar arasında güçlü bir bağımlılık olacaktı. Uzaktan kumanda veya telefon ile bağımlılık azaltılmış oluyor ayrıca televizyon tarafından sunulan ses açma komutu ile implementasyon kolaylaştırılmış oluyor. Her uzaktan kumanda televizyonun ses açma teknik altyapısını kendi üzerinde monte etmek zorunda kalmıyor. Sadece televizyonun ses açmak için cihazdan talep ettiği sinyali gönderiyor olması yeterli oluyor.

**Nasıl Yapılır?:** Üzerinde işlem yapılacak nesneyi constructor üzerinden parametre alacak bir command nesnesi oluşturulur. Command nesnesi aynı zamanda ilgili nesne üzerinde yapılacak işlem için bir fonksiyon sunar. 

**Anahtar Kod Bloğu:**

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
**Amaç:** Belli bir düzendeki metinlerin işlenmesi gereken durumlarda kullanılır.

**Örnek:** Gerçek hayatta da yaptığımız roma rakamlarının çözümlenmesi, kriptolanmış bir metnin çözümlenmesi gibi durumlarda kullanılabilir.

**Nasıl Yapılır?:** Öncelikle üzerinde çalışacağımız verileri tutacak context nesnesi oluşturulur. Daha sonra context nesnesi üzerinde işlem yapacak expression nesnelerinin implement edileceği expression interface'i oluşturulur. Bu interface üzerindeki bir fonksiyon yardımıyla context nesnesi parametre olarak alınır ve işlemler yapılır. Birden fazla expression nesnesi oluşturulabilir. 

**Anahtar Kod Bloğu:** Günün tarihini kullanıcının format tercihine göre formatlayan örnek.


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
**Amaç:** Bir koleksiyonun elemanlarını tiplerinden bağımsız gezmek için kullanılır.

**Örnek:** Örneğin bir postacının veya kargocunun listedeki bütün adresleri tek tek gezip paketleri bırakması örnek olabilir. Evde kimlerin yaşadığı, evin şekli vb özellikler postacıyı ilgilendirmez.

**Nasıl Yapılır?:**  Bunun  için programlama dillerinde artık bir çok hazır kütüphane gelmektedir. Bir çok dilde list, collection, enumerable, dictionary, array vb bir çok iterable nesne bulunur. Bu nesneler kullanılarak tasarım deseni kurgulanır. Öncelikle collection/dizi nesnesi oluşturulur. Daha sonra bu nesneyi parametre olarak alarak elemanları üzerinde gezebileceğimiz iterator nesnesi yazılır. 

**Anahtar Kod Bloğu:**

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
**Amaç:** Benzer işleri yapan nesneler arasındaki karmaşık bağımlılıkları gevşek bağımlılık ile ortadan kaldırmak için kullanılır. Anlamı da zaten arabulucudur.


**Örnek:** Örneğin havaalanına iniş yapmak isteyen uçaklar bir birleriyle değilde kule ile iletişime geçerler. Yada ev almak veya kiralamak isteyen kişiler kendi aralarında  veya satıcılarla doğrudan muhatap olmak yerine emlakçıya veya bir web sitesine giderler.

**Nasıl Yapılır?:**  Öncelikle birbirleriyle iletişime geçecek nesneler tanımlanır. Bu nesnelerin listesinin bulunduğu veya liste olmasa bile her bir nesnenin tanımının olduğu mediator nesnesi oluşturulur. Mediator nesnesi birbirleriyle iletişime geçecek nesnelerin constructor'una parametre olarak geçilir. Mediator nesnesi üzerinde diğer nesnelerle iletişim için bir fonksiyon bulunur. bütün nesneler mediator nesnesini parametre olarak aldığı için birbirleriyle iletişime geçebilirler. Aşağıdaki örnekte atılan mesaj herkese gitmektedir.

**Anahtar Kod Bloğu:**

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
            Mehmet.Send("Merhaba Arkadaşlar");
            Console.WriteLine();
            Zeynep.Send("Merhaba Murat");
            Console.Read();
        }
    }

```

- **Memento**: 
**Amaç:** Bir nesnenin iç yapısını ve uygulama detaylarını saklayarak önceki state'ine geri dönmeyi sağlamak için kullanılır. 

**Örnek:** Gerçek hayattan doğrudan bir örnek vermeye gerek yok. Bir objenin eski durumuna alındığı bütün durumlar bu tasarım desenine örnektir. 
 
**Nasıl Yapılır?:** Ana nesnemizi (originator) state'ini saklamak için bir memento nesnesi yazılır. Memento nesnesinde asıl nesnemizin state'i constructor üzerinden parametre alınır. Originator (ana nesne) memento nesnesini kendi state'ini vererek create eder Ancak bu state'in saklanması için bir başka nesne kullanılır (Caretaker).

**Anahtar Kod Bloğu:**  Aşağıdaki kodda SalesProspect nesnesi originator, ve ProspectMemory nesnesi de Caretaker nesnesidir.

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

**Amaç:** Bir nesnede meydana gelen değişiklikleri bunlardan haberdar olmak isteyen nesnelere duyurmak için kullanılır.

**Örnek:** Mesela bir dergiye abone oldunuz amacınız dergi çıktığında bu derginin size ulaşmasını sağlamak. Yada belli bir ürün için indirim olduğunda web sitesinin veya uygulamanın size sms göndermesini istemek örnek olarak gösterilebilir.

**Nasıl Yapılır?:**  Öncelikle diğer nesneler tarafından izlenecek olan nesne oluşturulur. Bu nesne üzerinde onu izleyecek nesnelerin yani observer'ların listesi ve bu listeye eleman eklemek için bir fonksiyon bulunur. Observer nesneleri aynı interface'i implement eder ve izlenen nesnede meydana gelen değişikliğin iletilmesi için bir fonksiyon sunarlar.  

**Anahtar Kod Bloğu:**

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
            Console.WriteLine("Ürünün satılabilir olup olmadığı durumu değişti.");
            NotifyObservers();
        }
        public void RegisterObserver(IObserver observer)
        {
            Console.WriteLine("Yeni Observer Eklendi: " + ((Observer)observer).UserName );
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
            Console.WriteLine("Ürün Adı :"
                            + ProductName + ", ürün Fiyatı : "
                            + ProductPrice + " artık satışa hazır. Bütün kayıtlı kullanıcıları uyarabilirsin.");
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
            Console.WriteLine("Merhaba " + UserName + ", Amazonda ürünün satılabilir durumu: " + availabiliy);
        }


class Program
    {
        static void Main(string[] args)
        {
            // ürünü stoklarda olmayacak şekilde kaydet.
            Subject RedMI = new Subject("Red MI Mobile", 10000, "Out Of Stock");

            //Murat kullanıcısını RedMI ürünün takipçi listesine ekle
            Observer user1 = new Observer("Murat", RedMI);

            //Can kullanıcısını RedMI ürünün takipçi listesine ekle
            Observer user2 = new Observer("Can", RedMI);

            //Jale kullanıcısını RedMI ürünün takipçi listesine ekle
            Observer user3 = new Observer("Jale", RedMI);
            
            Console.WriteLine("Red MI ürününün şuan ki durumu : " + RedMI.getAvailability());
            Console.WriteLine();
            // Ürün artık satışa hazır
            RedMI.setAvailability("Available");
            Console.Read();
        }
    }



```
- **State**: 
**Amaç:** Bir nesnenin iç durumu değiştiğinde davranışının da değişmesini sağlamak için kullanılır.

**Örnek:** Mesela gerçek hayatta kredi kartımızda anormal bir harcama olduğunda bankanın kartımızı kilitli duruma (state) getirmesi durumunda kartımızın artık harcama yapmamıza izin vermez. Aynı kartın durumu güvenliye geçtiğinde artık kredi kartı kullanılabilir duruma gelir. 

**Nasıl Yapılır?:**  Her state için bir nesne tasarlanır. Bu state nesnelerin ilgili state durumda iken yapılacak bütün işler için fonksiyonlar tanımlanır.  Yani A state'inde iken yapılacak işler ile B state'inde yapılacak işler tamamen aynıdır ancak yani her state'de yapılacak işlerin bir karşılığı vardır sonuç olarak hepsi aynı interface'i implement eder. Dana sonra asıl nesnemizi yani üzerinde çalışacağımız nesneyi state interface'ini parametre olarak alacak constructor ile veya public bir değişkenle tanımlarız.

**Anahtar Kod Bloğu:** 

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
            Console.WriteLine("{0:C} --- yatırıldı ", amount);
            Console.WriteLine(" Hesabınızdaki Para = {0:C}", this.Balance);
            Console.WriteLine(" Durum  = {0}",
                this.State.GetType().Name);
            Console.WriteLine("");
        }
        public void Withdraw(double amount)
        {
            state.Withdraw(amount);
            Console.WriteLine("{0:C} --- çekildi, ", amount);
            Console.WriteLine(" Hesabınızdaki Para = {0:C}", this.Balance);
            Console.WriteLine(" Durum  = {0}\n",
                this.State.GetType().Name);
        }
        public void PayInterest()
        {
            state.PayInterest();
            Console.WriteLine(" Yatırılan Faiz --- ");
            Console.WriteLine(" Hesabınıdaki Para = {0:C}", this.Balance);
            Console.WriteLine(" Durum  = {0}\n",
                this.State.GetType().Name);
        }
    }

```
- **Strategy**: 

**Amaç:** Çalışma anında aynı işi yapan bir grup algoritmadan birini seçebilmek için kullanılır.

**Örnek:** Akılda kalıcı olmasını sağlamak amacıyla buna doğrudan bir örnek vermektense şunu söylemek istiyorum, hayatınızda bir işi yapmanın birden çok yolu olmasına rağmen onlardan birini seçtiğiniz anları düşünün. Hatta bazı durumlarda aynı iş için farklı zamanlarda farklı yolu bile seçmiş olabilirsiniz.

**Nasıl Yapılır?:**  Aynı işi farklı yollarla yapan strategy nesneleri hepsi aynı interface'i implement edecek şekilde oluşturulur. Daha sonra bu nesneleri kullanacak nesnemizi oluştururuz. Bu nesne strategy nesnelerini implement ettiğimiz interface'i constructor  üzerinden parametre olarak alır.

**Anahtar Kod Bloğu:**

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

**Amaç:** Belli bir sırada/düzende yapılması gereken bir dizi işin hem sırasını/düzenini belirlemek hem de yapılacak bu işlerden bazılarının alt sınıflar tarafından yapılabilmesini sağlamak için kullanılır.

**Örnek:** Bir inşaatın yapılabilmesi bütün işlerin sırayla tamamlanması gerekir. Mütahitler aldıkları işi belli prosedürlere ve sırasına uygun şekilde yapmak durumundalar. Ancak bazı işleri de prosedürlerin izin verdiği ölçüde kendi bildikleri gibi de yapabilirler. Dolayısıyla aynı işi farklı mütahitler farklı şekilde yapabilir. Temel prosedürler aynı dahi olsa farklılık atacakları bir çok şey olacaktır.

**Nasıl Yapılır?:**  Genellikle temel işler için bir abstract class tanımlanır. Bu class içinde bütün fonksiyonlar iş yapmak zorunda değildir. Bazı işlerin alt sınıflar tarafından yapılmasına (override) yapılmasına izin verilir. Alt sınıflar bu abstract sınıfı miras alır ve istedikleri metotları override ederler.

**Anahtar Kod Bloğu:**

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

**Amaç:** Bir nesneyi değiştirmeden nesne üzerinde yeni operasyonlar çalıştırmamızı sağlayan tasarım desenidir.

**Örnek:** Örneğin bir okula aşı vurmak için bir doktorun geldiğini düşünelim. Normalde okulun öğrencilerine aşı vurmak gibi hizmeti yoktur yani asli işlerinden biri değildir. Aşıyı yapacak doktoru bir misafir olarak okula gelir ve okuldaki öğrencilere aşılarını yapar. Okulu yapısında (mesela organizasyon şemasını değiştirmeye) veya öğrencilerde herhangi bir değişiklik yapmaya (mesela aşı vurulacaklar diye farklı kıyafet giymelerine) gerek yoktur. 

**Nasıl Yapılır?:**  Aynı interface'in implement edildiği bir veya daha fazla visitor nesnesi oluşturulur. Bu visitor nesnelerinde yapılacak işler için metotlar eklenir. Daha sonra asıl üzerinde işlem yapacağımız nesnemizi/nesnelerimizi constructor üzerinden visitor interface'imizi parametre olarak alacak şekilde tanımlarız.

**Anahtar Kod Bloğu:** Her bir çalışan için maaş ve izin tanımlaması visitor nesnesi ile yapılmıştır.

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


Umarım faydalı olmuştur.

Bir sonraki yazımızda tasarım desenlerinin birbirleriyle olan ilişkilerine, benzer ve farklı oldukları yerlere değineceğiz.


# Kaynaklar
- https://egitimbilimlerinotlari.com/bilgi-isleme-kuraminin-temel-kavramlari/
- https://tr.wikipedia.org/wiki/Loci_Metodu
- https://ogrencikariyeri.com/haber/verimli-ders-calismanin-en-etkili-yontemleri
- https://hackernoon.com/how-to-remember-design-patterns-ap1z35sl
- https://www.codeproject.com/tips/57578/the-best-way-to-remember-design-patterns
- https://en.wikipedia.org/wiki/Design_Patterns
- https://dotnettutorials.net/course/dot-net-design-patterns/
- https://refactoring.guru/design-patterns
- https://www.dofactory.com/
