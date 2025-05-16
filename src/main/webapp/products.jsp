<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>Управление продуктами</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4">Добавить категорию</h2>
    <form id="category-form" class="row g-3 mb-5">
        <div class="col-md-6">
            <input type="text" class="form-control" name="name" placeholder="Название категории" required>
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-primary">Создать категорию</button>
        </div>
    </form>

    <h2 class="mb-4">Добавить продукт</h2>
    <form id="product-form" class="row g-3 mb-5">
        <div class="col-md-4">
            <input type="text" class="form-control" name="name" placeholder="Название продукта" required>
        </div>
        <div class="col-md-4">
            <input type="text" class="form-control" name="description" placeholder="Описание" required>
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control" name="unit" placeholder="Ед. изм." required>
        </div>
        <div class="col-md-4">
            <select class="form-select" name="category" required>
                <option value="">Выберите категорию</option>
            </select>
        </div>
        <div class="col-md-4">
            <input type="text" class="form-control" name="manufacturer" placeholder="Производитель" required>
        </div>
        <div class="col-md-2">
            <button type="submit" class="btn btn-success">Сохранить продукт</button>
        </div>
    </form>

    <h2 class="mb-3">Список продуктов</h2>
    <div id="product-list" class="row row-cols-1 row-cols-md-2 g-3"></div>
</div>

<script>
    const categoryForm = document.getElementById('category-form');
    const productForm = document.getElementById('product-form');
    const categorySelect = productForm.category;
    const productList = document.getElementById('product-list');

    // Создание новой категории
    categoryForm.addEventListener('submit', function (e) {
        e.preventDefault();
        const category = { name: categoryForm.name.value };

        fetch('/api/categories', {
            method: 'POST',
            headers: {'Content-Type': 'application/json;charset=UTF-8'},
            body: JSON.stringify(category)
        }).then(() => {
            categoryForm.reset();
            loadCategories();
        });
    });

    // Создание нового продукта
    productForm.addEventListener('submit', function (e) {
        e.preventDefault();

        const product = {
            name: productForm.name.value,
            description: productForm.description.value,
            unit: productForm.unit.value,
            category: { name: categorySelect.value },
            manufacturer: productForm.manufacturer.value
        };

        fetch('/api/products', {
            method: 'POST',
            headers: {'Content-Type': 'application/json;charset=UTF-8'},
            body: JSON.stringify(product)
        }).then(() => {
            productForm.reset();
            loadProducts();
        });
    });

    // Загрузка списка категорий
    function loadCategories() {
        fetch('/api/categories')
            .then(response => response.json())
            .then(categories => {
                categorySelect.innerHTML = '<option value="">Выберите категорию</option>';
                categories.forEach(cat => {
                    const option = document.createElement('option');
                    option.value = cat.name;
                    option.textContent = cat.name;
                    categorySelect.appendChild(option);
                });
            });
    }

    // Загрузка списка продуктов
    function loadProducts() {
        fetch('/api/products')
            .then(response => response.json())
            .then(products => {
                productList.innerHTML = '';
                products.forEach(p => {
                    const card = document.createElement('div');
                    card.className = 'col';
                    card.innerHTML = `
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">${p.name}</h5>
                                <p class="card-text">${p.description}</p>
                                <p class="card-text"><strong>Категория:</strong> ${p.category.name}</p>
                                <p class="card-text"><strong>Ед. изм.:</strong> ${p.unit}</p>
                                <p class="card-text"><strong>Производитель:</strong> ${p.manufacturer}</p>
                            </div>
                        </div>
                    `;
                    productList.appendChild(card);
                });
            });
    }

    // Инициализация данных при загрузке страницы
    loadCategories();
    loadProducts();
</script>

</body>
</html>
