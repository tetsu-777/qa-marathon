-- 顧客テーブルの作成
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(255),
    Industry VARCHAR(255),
    Contact VARCHAR(20),
    Location VARCHAR(255)
);

-- 案件テーブルの作成
CREATE TABLE Cases (
    CaseID SERIAL PRIMARY KEY,
    CaseName VARCHAR(255),
    CaseStatus VARCHAR(255),
    ExpectedRevenue DECIMAL(10, 2),
    Representative VARCHAR(255),
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 商談履歴テーブルの作成
CREATE TABLE Negotiations (
    NegotiationID SERIAL PRIMARY KEY,
    NegotiationDate DATE,
    NegotiationContent TEXT,
    NegotiationConfidence DECIMAL(3, 2),
    NegotiationRepresentative VARCHAR(255),
    CaseID INT,
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID)
);
