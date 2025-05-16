package model;

public class Product {
    private Integer id;
    private String name;
    private String description;
    private String unit;
    private String manufacturer;
    private Category category;

    public Product() {}

    public Integer getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
}
