package repository;

import config.DBConnection;
import model.Category;
import model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductRepository {
    private final CategoryRepository categoryRepository = new CategoryRepository();

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.id, p.name, p.description, p.unit, p.manufacturer, p.category_id, c.name as category_name " +
                "FROM product p LEFT JOIN category c ON p.category_id = c.id ORDER BY p.name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));
                p.setUnit(rs.getString("unit"));
                p.setManufacturer(rs.getString("manufacturer"));

                int categoryId = rs.getInt("category_id");
                if (!rs.wasNull()) {
                    Category c = new Category();
                    c.setId(categoryId);
                    c.setName(rs.getString("category_name"));
                    p.setCategory(c);
                }

                products.add(p);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return products;
    }

    public Product getProductById(int id) {
        String sql = "SELECT p.id, p.name, p.description, p.unit, p.manufacturer, p.category_id, c.name as category_name " +
                "FROM product p LEFT JOIN category c ON p.category_id = c.id WHERE p.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try(ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setDescription(rs.getString("description"));
                    p.setUnit(rs.getString("unit"));
                    p.setManufacturer(rs.getString("manufacturer"));
                    int categoryId = rs.getInt("category_id");
                    if (!rs.wasNull()) {
                        Category c = new Category();
                        c.setId(categoryId);
                        c.setName(rs.getString("category_name"));
                        p.setCategory(c);
                    }
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void saveProduct(Product product) {
        String sql = "INSERT INTO product (name, description, unit, manufacturer, category_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getUnit());
            ps.setString(4, product.getManufacturer());
            if (product.getCategory() != null) {
                ps.setInt(5, product.getCategory().getId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    product.setId(keys.getInt(1));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateProduct(Product product) {
        String sql = "UPDATE product SET name = ?, description = ?, unit = ?, manufacturer = ?, category_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, product.getName());
            ps.setString(2, product.getDescription());
            ps.setString(3, product.getUnit());
            ps.setString(4, product.getManufacturer());
            if (product.getCategory() != null) {
                ps.setInt(5, product.getCategory().getId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }
            ps.setInt(6, product.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM product WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
