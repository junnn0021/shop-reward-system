CREATE TABLE `customer` (
    `customer_id` varchar(200)  NOT NULL ,
    `customer_name` varchar(200)  NOT NULL ,
    `customer_email` varchar(200)  NOT NULL ,
    PRIMARY KEY (
        `customer_email`
    )
);

INSERT INTO customer (customer_id, customer_name, customer_email) VALUES ('hi8294', 'hi', 'hi8294@naver.com');

CREATE TABLE `product` (
    `product_id` varchar(200)  NOT NULL ,
    `product_name` varchar(200)  NOT NULL ,
    `product_count` varchar(200)  NOT NULL ,
    PRIMARY KEY (
        `product_id`
    )
);

INSERT INTO product (product_id, product_name, product_count) VALUES ('P-1234', '물', '3');

CREATE TABLE 'purchasedetails' (

);