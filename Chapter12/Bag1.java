import java.util.ArrayList;

public class Bag
{
    ArrayList<Object> items = new ArrayList<Object>();

    public void add(final Object object) {
        this.items.add(object);
    }

    public void addMany(final Object[] objects) {
        for (Object obj : objects) {
            this.add(obj);
        }
    }

    public String toString() {
        StringBuilder builder = new StringBuilder();
        builder.append("Bag: ");
        for (int i = 0; i < items.size(); i++) {
            if (i > 0) {
                builder.append(",");
            }
            builder.append(items.get(i));
        }
        return builder.toString();
    }
}

