// 보상 테이블 생성
CREATE TABLE `Reward` (
    `Reward_Id` varchar(100) NOT NULL ,
    `Reward_Name` varchar(100)  NOT NULL ,
    `Reward_Count` INT  NOT NULL ,
    `Reward_Attendance_Day` INT  NOT NULL ,
    PRIMARY KEY ( Reward_Attendance_Day )
);

// 유저테이블 생성
CREATE TABLE `User` (
    `User_Id` INT NOT NULL ,
    `User_Email` varchar(100)  NOT NULL ,
    `Attendance_Day` INT  NOT NULL ,
    `Reward_Name` varchar(100),
    PRIMARY KEY (User_Email) ,
    FOREIGN KEY (Attendance_Day) REFERENCES Reward (Reward_Attendance_Day)
);

//  수령 테이블
CREATE TABLE `Receipt` (
    `Receipt_Id` INT NOT NULL,
    `Receipt_Email` varchar(100) NOT NULL ,
    `Receipt_Name` varchar(100) NOT NULL ,
     PRIMARY KEY (Receipt_Id)
     FOREIGN KEY (Receipt_Email) REFERENCES User (User_Email)
);

// 수령 테이블 데이터
INSERT INTO Receipt (Receipt_ID, Receipt_Email, Receipt_Name) VALUES (1,'junnn0021@gmail.com','에어팟 프로 1세대')

// 보상 테이블 데이터
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_1','츄파츕스',200,1);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_2','빼빼로',200,2);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_3','페레로로쉐 3구',200,3);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_4','코카콜라 1.25L',200,4);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_5','CU 5천원 상품권',200,5 );
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_6','샤오미 무선 보조 배터리',100,6);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_7','하만 필름 카메라',100,7);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_8','무선 전동 안마기',100,8);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_9','콤팩트 룸 스프레이',100,9);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_10','CU 5만원 상품권',100,10);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_11','아웃백 10만원 기프트카드',50,11);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_12','한우선물세트 1등급 1.4kg',50,12);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_13','에어팟 프로 1세대',50,13);
INSERT INTO Reward (Reward_id, Reward_Name, Reward_Count, Reward_Attendance_Day) VALUES('reward_14','아이패드 10세대',50,14);

// 유저 테이블 데이터
INSERT INTO User (User_Id, User_Email, Attendance_Day, Reward_Name) VALUES(1,'leeih10@gmail.com',6,'샤오미 무선 보조 배터리');
INSERT INTO User (User_Id, User_Email, Attendance_Day, Reward_Name) VALUES(2,'vhxh20778@gmail.com',7,'');
INSERT INTO User (User_Id, User_Email, Attendance_Day, Reward_Name) VALUES(3,'junnn0021@gmail.com',13,'에어팟 프로 1세대');
INSERT INTO User (User_Id, User_Email, Attendance_Day, Reward_Name) VALUES(4,'style056811@gmail.com',12,'');

// 고객이 자신의 출석일수에 맞게 뭘 수령할 수 있는지 조회 쿼리.
select User_Email, Attendance_Day, Reward.Reward_Name
from User
JOIN Reward ON User.Attendance_Day = Reward.Reward_Attendance_Day;

// 리워드 상품 조회 쿼리.
select * from Reward;

// 수령한 상품 조회 쿼리.
select * from Receipt;