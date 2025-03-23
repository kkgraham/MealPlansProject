-- Create table for cooking methods
CREATE TABLE cooking_methods (
    method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    avg_cooking_time INT
);

-- Create table for measurement units
CREATE TABLE measurement_units (
    unit_id SERIAL PRIMARY KEY,
    unit_name VARCHAR(30) NOT NULL UNIQUE,
    abbreviation VARCHAR(10)
);

-- Create table for ingredient categories (like dairy, meat, vegetables, etc.)
CREATE TABLE ingredient_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    is_seasonal BOOLEAN DEFAULT FALSE
);

-- Create table for ingredients
CREATE TABLE ingredients (
    ingredient_id SERIAL PRIMARY KEY,
    ingredient_name VARCHAR(100) NOT NULL UNIQUE,
    category_id INT,
    avg_price_per_unit DECIMAL(10, 2),
    default_unit_id INT,
    shelf_life_days INT,
    is_staple BOOLEAN DEFAULT FALSE,
    is_seasonal BOOLEAN DEFAULT FALSE,
    season_start INT, -- Start month (1-12) if seasonal
    season_end INT, -- End month (1-12) if seasonal
    FOREIGN KEY (category_id) REFERENCES ingredient_categories(category_id),
    FOREIGN KEY (default_unit_id) REFERENCES measurement_units(unit_id)
);

-- Create table for recipe categories (breakfast, lunch, dinner, dessert, etc.)
CREATE TABLE recipe_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Create table for recipes
CREATE TABLE recipes (
    recipe_id SERIAL PRIMARY KEY,
    recipe_name VARCHAR(100) NOT NULL,
    category_id INT,
    primary_method_id INT,
    prep_time_minutes INT,
    cook_time_minutes INT,
    servings INT,
    instructions TEXT NOT NULL,
    source VARCHAR(255),
    notes TEXT,
    is_favorite BOOLEAN DEFAULT FALSE,
    rating SMALLINT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (category_id) REFERENCES recipe_categories(category_id),
    FOREIGN KEY (primary_method_id) REFERENCES cooking_methods(method_id)
);

-- Create table for recipe-ingredient relationships
CREATE TABLE recipe_ingredients (
    recipe_id INT,
    ingredient_id INT,
    quantity DECIMAL(10, 3),
    unit_id INT,
    preparation VARCHAR(100), -- How the ingredient should be prepared (e.g., "chopped", "minced")
    is_optional BOOLEAN DEFAULT FALSE,
    substitute_ingredient_id INT, -- Possible substitute ingredient
    PRIMARY KEY (recipe_id, ingredient_id),
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES measurement_units(unit_id),
    FOREIGN KEY (substitute_ingredient_id) REFERENCES ingredients(ingredient_id)
);

-- Create table for ingredient inventory (what's currently in stock)
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    ingredient_id INT,
    quantity DECIMAL(10, 3),
    unit_id INT,
    purchase_date DATE,
    expiration_date DATE,
    notes TEXT,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES measurement_units(unit_id)
);

-- Create table for meal plans
CREATE TABLE meal_plans (
    plan_id SERIAL PRIMARY KEY,
    plan_name VARCHAR(100),
    start_date DATE,
    end_date DATE,
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create table for meal plan items
CREATE TABLE meal_plan_items (
    plan_id INT,
    recipe_id INT,
    planned_date DATE,
    meal_type VARCHAR(10) CHECK (meal_type IN ('Breakfast', 'Lunch', 'Dinner', 'Snack', 'Other')),
    servings INT,
    notes TEXT,
    PRIMARY KEY (plan_id, recipe_id, planned_date, meal_type),
    FOREIGN KEY (plan_id) REFERENCES meal_plans(plan_id) ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);

-- Create table for shopping lists
CREATE TABLE shopping_lists (
    list_id SERIAL PRIMARY KEY,
    list_name VARCHAR(100),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    is_completed BOOLEAN DEFAULT FALSE
);

-- Create table for shopping list items
CREATE TABLE shopping_list_items (
    list_id INT,
    ingredient_id INT,
    quantity DECIMAL(10, 3),
    unit_id INT,
    is_purchased BOOLEAN DEFAULT FALSE,
    notes TEXT,
    PRIMARY KEY (list_id, ingredient_id),
    FOREIGN KEY (list_id) REFERENCES shopping_lists(list_id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(ingredient_id),
    FOREIGN KEY (unit_id) REFERENCES measurement_units(unit_id)
);

-- Insert some sample cooking methods
INSERT INTO cooking_methods (method_name, description, avg_cooking_time) VALUES
('Baking', 'Cooking in an oven with dry heat', 45),
('Boiling', 'Cooking in boiling water', 20),
('Slow Cooker', 'Cooking slowly in a crock pot', 240),
('Stovetop', 'Cooking on a stovetop burner', 30),
('Grilling', 'Cooking with direct heat from below', 15),
('Microwave', 'Cooking using microwave radiation', 5),
('Pressure Cooker', 'Cooking under pressure', 25),
('Air Fryer', 'Cooking with circulated hot air', 15);

-- Insert some sample measurement units
INSERT INTO measurement_units (unit_name, abbreviation) VALUES
('Cup', 'cup'),
('Tablespoon', 'tbsp'),
('Teaspoon', 'tsp'),
('Ounce', 'oz'),
('Pound', 'lb'),
('Gram', 'g'),
('Kilogram', 'kg'),
('Milliliter', 'ml'),
('Liter', 'L'),
('Pinch', 'pinch'),
('Each', 'ea'),
('Bunch', 'bunch'),
('Clove', 'clove');

-- Insert some sample ingredient categories
INSERT INTO ingredient_categories (category_name, description, is_seasonal) VALUES
('Meat', 'Animal-based protein sources', FALSE),
('Poultry', 'Chicken, turkey, and other birds', FALSE),
('Seafood', 'Fish and shellfish', TRUE),
('Dairy', 'Milk-based ingredients', FALSE),
('Vegetables', 'Plant-based foods', TRUE),
('Fruits', 'Sweet plant-based foods', TRUE),
('Grains', 'Wheat, rice, oats, and other grains', FALSE),
('Legumes', 'Beans, lentils, and peas', FALSE),
('Nuts and Seeds', 'Edible seeds and tree nuts', FALSE),
('Herbs and Spices', 'Flavor enhancers', FALSE),
('Baking', 'Ingredients used primarily in baking', FALSE),
('Condiments', 'Sauces, dressings, and spreads', FALSE),
('Oils and Vinegars', 'Cooking oils and vinegars', FALSE),
('Beverages', 'Drinkable ingredients', FALSE),
('Other', 'Miscellaneous ingredients', FALSE);

-- Insert some sample recipe categories
INSERT INTO recipe_categories (category_name, description) VALUES
('Breakfast', 'Morning meals'),
('Lunch', 'Midday meals'),
('Dinner', 'Evening meals'),
('Dessert', 'Sweet treats'),
('Appetizer', 'Small pre-meal dishes'),
('Side Dish', 'Accompaniments to main courses'),
('Snack', 'Between-meal foods'),
('Soup', 'Liquid-based dishes'),
('Salad', 'Primarily vegetable-based cold dishes'),
('Bread', 'Baked dough products'),
('Beverage', 'Drinks'),
('Meal Prep', 'Dishes specifically for meal preparation');

-- Create view for available recipes (recipes that can be made with current inventory)
CREATE OR REPLACE VIEW available_recipes AS
SELECT r.recipe_id, r.recipe_name
FROM recipes r
WHERE NOT EXISTS (
    SELECT ri.ingredient_id
    FROM recipe_ingredients ri
    WHERE ri.recipe_id = r.recipe_id
    AND ri.is_optional = FALSE
    AND NOT EXISTS (
        SELECT 1
        FROM inventory i
        WHERE i.ingredient_id = ri.ingredient_id
        AND i.quantity >= ri.quantity
    )
);

-- Create view for partially available recipes (recipes where you have some ingredients)
CREATE OR REPLACE VIEW partially_available_recipes AS
SELECT 
    r.recipe_id, 
    r.recipe_name,
    COUNT(DISTINCT ri.ingredient_id) AS total_ingredients,
    COUNT(DISTINCT i.ingredient_id) AS available_ingredients,
    (COUNT(DISTINCT i.ingredient_id) * 100.0 / COUNT(DISTINCT ri.ingredient_id)) AS percentage_available
FROM 
    recipes r
JOIN 
    recipe_ingredients ri ON r.recipe_id = ri.recipe_id
LEFT JOIN 
    inventory i ON ri.ingredient_id = i.ingredient_id AND i.quantity >= ri.quantity
WHERE 
    r.recipe_id NOT IN (SELECT recipe_id FROM available_recipes)
GROUP BY 
    r.recipe_id, r.recipe_name
HAVING 
    COUNT(DISTINCT i.ingredient_id) > 0;