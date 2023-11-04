-- 顧客テーブルの作成
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CompanyName VARCHAR(255) NOT NULL,
    Industry VARCHAR(255) NOT NULL,
    Contact VARCHAR(20) NOT NULL UNIQUE CHECK (Contact <> ''),
    Location VARCHAR(255) NOT NULL,
    CreatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 案件テーブルの作成
CREATE TABLE Cases (
    CaseID SERIAL PRIMARY KEY,
    CaseName VARCHAR(255) NOT NULL,
    CaseStatus VARCHAR(255) NOT NULL CHECK (CaseStatus IN ('初期段階', '交渉中', '契約締結', '保留中')),
    ExpectedRevenue DECIMAL(10, 2) CHECK (ExpectedRevenue >= 0),
    Representative VARCHAR(255) NOT NULL,
    CustomerID INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CreatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 商談履歴テーブルの作成
CREATE TABLE Negotiations (
    NegotiationID SERIAL PRIMARY KEY,
    NegotiationDate DATE NOT NULL,
    NegotiationContent TEXT NOT NULL,
    NegotiationConfidence DECIMAL(3, 2) NOT NULL CHECK (NegotiationConfidence BETWEEN 0 AND 1),
    NegotiationRepresentative VARCHAR(255) NOT NULL,
    CaseID INT NOT NULL,
    FOREIGN KEY (CaseID) REFERENCES Cases(CaseID),
    CreatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 関数の作成
CREATE OR REPLACE FUNCTION update_updated_date()
RETURNS TRIGGER AS $$
BEGIN
    NEW.UpdatedDate = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 各テーブルにトリガーを設定
CREATE TRIGGER update_customers_updated_date BEFORE UPDATE ON Customers FOR EACH ROW EXECUTE PROCEDURE update_updated_date();
CREATE TRIGGER update_cases_updated_date BEFORE UPDATE ON Cases FOR EACH ROW EXECUTE PROCEDURE update_updated_date();
CREATE TRIGGER update_negotiations_updated_date BEFORE UPDATE ON Negotiations FOR EACH ROW EXECUTE PROCEDURE update_updated_date();
