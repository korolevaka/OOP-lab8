package model;

public class Product {
    private String name;
    private String description;
    private String unit;
    private Category category;
    private String manufacturer;

    public Product() {}

    public Product(String name, String description, String unit, Category category, String manufacturer) {
        this.name = name;
        this.description = description;
        this.unit = unit;
        this.category = category;
        this.manufacturer = manufacturer;
    }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }

    public String getManufacturer() { return manufacturer; }
    public void setManufacturer(String manufacturer) { this.manufacturer = manufacturer; }
}
