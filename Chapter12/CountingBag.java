public class CountingBag extends Bag
{
    int count = 0;

    public void add(Object object) {
        super.add(object);
        this.count += 1;
    }

    public int size() {
        return count;
    }

    public String toString() {
        return super.toString();
    }

    public static void main(String[] args) {
        CountingBag cbag = new CountingBag();
        cbag.add("apple");
        cbag.addMany(new Object[] { "banana", "orange"});
        System.out.println(cbag.toString());
        System.out.print("=> has ");
        System.out.print(cbag.size());
        System.out.println(" items.");
    }
}

