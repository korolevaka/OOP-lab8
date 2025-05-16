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

    <h3>Список категорий</h3>
    <ul id="category-list" class="list-group mb-5"></ul>

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
    const categoryList = document.getElementById('category-list');
    const productList = document.getElementById('product-list');

    // Загрузка списка категорий
    function loadCategories() {
        fetch('/api/categories')
            .then(res => res.json())
            .then(categories => {
                categorySelect.innerHTML = '<option value="">Выберите категорию</option>';
                categoryList.innerHTML = '';
                categories.forEach(cat => {
                    const option = document.createElement('option');
                    option.value = cat.id;
                    option.textContent = cat.name;
                    categorySelect.appendChild(option);

                    const li = document.createElement('li');
                    li.className = 'list-group-item d-flex justify-content-between align-items-center';
                    li.textContent = cat.name;

                    const btnGroup = document.createElement('div');

                    const editBtn = document.createElement('button');
                    editBtn.className = 'btn btn-sm btn-warning me-2';
                    editBtn.textContent = 'Редактировать';
                    editBtn.onclick = () => editCategory(cat);

                    const deleteBtn = document.createElement('button');
                    deleteBtn.className = 'btn btn-sm btn-danger';
                    deleteBtn.textContent = 'Удалить';
                    deleteBtn.onclick = () => deleteCategory(cat.id);

                    btnGroup.appendChild(editBtn);
                    btnGroup.appendChild(deleteBtn);

                    li.appendChild(btnGroup);
                    categoryList.appendChild(li);
                });
            });
    }

    // Загрузка списка продуктов
    function loadProducts() {
        fetch('/api/products')
            .then(res => res.json())
            .then(products => {
                productList.innerHTML = '';
                products.forEach(p => {
                    const card = document.createElement('div');
                    card.className = 'col';

                    // Безопасное получение данных с проверкой и подстановкой значения по умолчанию
                    const name = p.name || 'Без названия';
                    const description = p.description || 'Описание отсутствует';
                    const categoryName = (p.category && p.category.name) ? p.category.name : 'Категория не указана';
                    const unit = p.unit || 'Ед. изм. не указано';
                    const manufacturer = p.manufacturer || 'Производитель не указан';

                    card.innerHTML = `
                        <div class="card shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title">${name}</h5>
                                <p class="card-text">${description}</p>
                                <p class="card-text"><strong>Категория:</strong> ${categoryName}</p>
                                <p class="card-text"><strong>Ед. изм.:</strong> ${unit}</p>
                                <p class="card-text"><strong>Производитель:</strong> ${manufacturer}</p>
                                <button class="btn btn-sm btn-warning me-2 edit-product-btn">Редактировать</button>
                                <button class="btn btn-sm btn-danger delete-product-btn">Удалить</button>
                            </div>
                        </div>
                    `;

                    // Добавляем обработчики кнопок
                    card.querySelector('.edit-product-btn').onclick = () => editProduct(p);
                    card.querySelector('.delete-product-btn').onclick = () => deleteProduct(p.id);

                    productList.appendChild(card);
                });
            })
            .catch(error => {
                console.error('Ошибка загрузки продуктов:', error);
                productList.innerHTML = '<p class="text-danger">Ошибка загрузки списка продуктов.</p>';
            });
    }


    // Создание категории
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

    // Создание / обновление продукта
    productForm.addEventListener('submit', function (e) {
        e.preventDefault();

        const product = {
            name: productForm.name.value,
            description: productForm.description.value,
            unit: productForm.unit.value,
            category: { id: +categorySelect.value },
            manufacturer: productForm.manufacturer.value
        };

        if (productForm.dataset.editingId) {
            fetch('/api/products/' + productForm.dataset.editingId, {
                method: 'PUT',
                headers: {'Content-Type': 'application/json;charset=UTF-8'},
                body: JSON.stringify(product)
            }).then(() => {
                productForm.reset();
                delete productForm.dataset.editingId;
                productForm.querySelector('button[type=submit]').textContent = 'Сохранить продукт';
                loadProducts();
            });
        } else {
            fetch('/api/products', {
                method: 'POST',
                headers: {'Content-Type': 'application/json;charset=UTF-8'},
                body: JSON.stringify(product)
            }).then(() => {
                productForm.reset();
                loadProducts();
            });
        }
    });

    // Редактирование категории
    function editCategory(category) {
        const newName = prompt('Введите новое имя категории:', category.name);
        if (newName && newName.trim() !== '') {
            fetch('/api/categories/' + category.id, {
                method: 'PUT',
                headers: {'Content-Type': 'application/json;charset=UTF-8'},
                body: JSON.stringify({name: newName})
            }).then(() => loadCategories());
        }
    }

    // Удаление категории
    function deleteCategory(id) {
        if (confirm('Удалить категорию?')) {
            fetch('/api/categories/' + id, {
                method: 'DELETE'
            }).then(() => loadCategories());
        }
    }

    // Редактирование продукта
    function editProduct(product) {
        productForm.name.value = product.name || '';
        productForm.description.value = product.description || '';
        productForm.unit.value = product.unit || '';
        productForm.manufacturer.value = product.manufacturer || '';
        productForm.category.value = product.category ? product.category.id : '';
        productForm.dataset.editingId = product.id;
        productForm.querySelector('button[type=submit]').textContent = 'Обновить продукт';
    }

    // Удаление продукта
    function deleteProduct(id) {
        if (confirm('Удалить продукт?')) {
            fetch('/api/products/' + id, {
                method: 'DELETE'
            }).then(() => loadProducts());
        }
    }

    // Инициализация данных при загрузке страницы
    loadCategories();
    loadProducts();
</script>

</body>
</html>
