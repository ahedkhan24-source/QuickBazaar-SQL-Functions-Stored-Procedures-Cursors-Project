use quickbazaar_db;

DELIMITER $$ 
CREATE  FUNCTION fn_calculate_margin( p_price DECIMAL(10,2), p_cost DECIMAL(10,2) ) RETURNS DECIMAL(5,2)
 DETERMINISTIC NO SQL
 BEGIN 
 DECLARE v_margin DECIMAL(5,2); 
 IF p_price <= 0 THEN SET v_margin = 0.00; 
 ELSE SET v_margin = ((p_price - p_cost) / p_cost) * 100; 
 END IF; 
 RETURN v_margin; 
 END
 $$ DELIMITER ;
 
 select price,cost_price
 ,fn_calculate_margin(price,cost_price) as profit_margin
 from products;
 
 -- Classify customer loyalty status based on points balance: >= 100: 'Gold',
 -- >= 50: 'Silver', else 'Bronze'.
 
 
 
 DELIMITER $$ 
CREATE  FUNCTION fn_tier( points int ) RETURNS varchar(10)
 DETERMINISTIC NO SQL
 BEGIN 
 DECLARE tier varchar(10); 
 IF points >=100 THEN SET tier = 'GOLD';
 elseif points>=50 then set tier = "SILVER";
 ELSE SET tier="BRONZE"; 
 END IF; 
 RETURN tier; 
 END
 $$ DELIMITER ;
 
 select *,fn_tier(loyalty_points)
 from customers;
 
 
 select *, fn_tier(quantity_to_stock) from products;
 
 
 
 /*
 Create a scalar function named
 fn_format_full_name that takes
 first_name and 
 last_name as inputs and returns them capitalized and concatenated in this
 format: "LASTNAME, Firstname".*/
 
 DELIMITER $$ 
CREATE  FUNCTION fn_format_full_name( fn varchar(20),ln varchar(20) ) RETURNS varchar(50)
 DETERMINISTIC NO SQL
 BEGIN 
 DECLARE full_name varchar(50); 
 set full_name = concat(upper(ln), ',',' ',fn);
 RETURN full_name; 
 END;
 $$ DELIMITER ;
 
 
 
 
select * ,fn_format_full_name(first_name,last_name) as full_name
from customers;


select * ,fn_format_full_name(product_name,category) as joined 
from products;

DELIMITER //

CREATE PROCEDURE get_customers()
BEGIN
    SELECT * FROM customers;
END //

DELIMITER ;


call get_customers;

use quickbazaar_db;

delimiter $$ 
create procedure proc_customers_order()
begin
 select * from customers;
 select * from orders;
 end;
 $$ delimiter ;
 
 
 
 call proc_customers_order();
 
 
delimiter $$ 
create procedure all_city_customers(in city_name varchar(25))
 begin
 select c.customer_id,c.first_name,c.email,o.total_amount
 from customers c join orders o 
on c.customer_id=o.customer_id
where c.city= city_name;
end;
$$ delimiter ;

call all_city_customers('Mumbai');

-- cursor 




DELIMITER $$ 
CREATE PROCEDURE sp_audit_inventory_valuation() 

BEGIN 

DECLARE 

v_done 

INT DEFAULT 0; 

DECLARE v_name VARCHAR(100); 

DECLARE v_cost DECIMAL(10,2); 

DECLARE v_units INT; 

DECLARE v_item_valuation DECIMAL(12,2); 

DECLARE v_total_valuation DECIMAL(14,2) DEFAULT 0.00; 

DECLARE cur_products CURSOR FOR SELECT product_name, cost_price, quantity_in_stock FROM products; 

DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1; 

OPEN cur_products; 

audit_loop: LOOP 

FETCH cur_products INTO v_name, v_cost, v_units; 

IF v_done = 1 THEN LEAVE audit_loop; 

END IF; 

SET v_item_valuation = v_units * v_cost; 

SET v_total_valuation = v_total_valuation + v_item_valuation; 

END LOOP; CLOSE cur_products; 

SELECT v_total_valuation AS total_warehouse_cost_value; 

END 

$$ DELIMITER ;
 
 
 
 
 
 
 
 
 DELIMITER $$ 

CREATE PROCEDURE bonus_evaluation() 

BEGIN 

declare v_done int default 0;

declare v_name varchar(20);

declare v_city varchar(20);

declare bonus_value int;

DECLARE cur_customers CURSOR 

FOR SELECT first_name, city FROM customer; 

DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1; 

OPEN cur_customers; 

audit_loop: LOOP 

FETCH cur_customers INTO v_name, v_city; 

IF v_done = 1 THEN LEAVE audit_loop; 

END IF; 

if v_city='Mumbai' then set bonus_value = 50;

else set bonus_value =20;

end if;

update customers set loyalty_points =  loyalty_points + bonus_value

where first_name = v_name;

END LOOP; 

CLOSE cur_customers; 

SELECT * from customers; 

END 

$$ DELIMITER ;



call bonus_evaluation;