//
//  DBHelper.swift
//  databaseTest
//
//  Created by Park on 2023/05/10.
//

import SwiftUI
import SQLite3

class DBHelper{
    static let shared = DBHelper()
    
    var db : OpaquePointer?
    let databaseName = "dbTest.sqlite"
    
    init(){
        self.db = createDB()
        createTable()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    private func createDB() -> OpaquePointer?{
        var db : OpaquePointer? = nil
        
        do{
            let dbPath: String = try FileManager.default.url(
                for:.documentDirectory,
                in:.userDomainMask,
                appropriateFor: nil,
                create:false).appendingPathComponent(databaseName).path
            
            if sqlite3_open(dbPath, &db) == SQLITE_OK{
                print("Successfully created DB. Path: \(dbPath)")
                return db
            }
        }
        catch {
            print("Error while creating Database -\(error.localizedDescription)")
        }
        return nil
    }
    
    func createTable(){
        let queryVoca = """
            CREATE TABLE IF NOT EXISTS myVocaList(
            word CHAR(20) NOT NULL,
            meaning CHAR(20) NOT NULL
            );
            """
        let queryDiary = """
            CREATE TABLE IF NOT EXISTS myDiary(
            title CHAR(20) NOT NULL,
            contents TEXT NOT NULL
            );
            """
        
        var statementVoca: OpaquePointer? = nil
        var statementDiary: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, queryVoca, -1, &statementVoca, nil) == SQLITE_OK && sqlite3_prepare_v2(self.db, queryDiary, -1, &statementDiary, nil) == SQLITE_OK {
            if sqlite3_step(statementVoca) == SQLITE_DONE {
                print("Creating vocaTable has been succesfully done. db: \(String(describing: self.db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating vocaTable: \(errorMessage)")
            }
            if sqlite3_step(statementDiary) == SQLITE_DONE {
                print("Creating diaryTable has been succesfully done. db: \(String(describing: self.db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\nsqlte3_step failure while creating diaryTable: \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(self.db))
            print("\nsqlite3_prepare failure while creating table: \(errorMessage)")
        }
        
        sqlite3_finalize(statementDiary)
        sqlite3_finalize(statementVoca)
    }
    
    func insertVoca(word: String, meaning: String) {
        let insertQuery = "insert into myVocaList (word, meaning) values (?, ?);"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (word as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (meaning as NSString).utf8String, -1, nil)
        }
        else {
            print("sqlite binding failure")
        }
        if sqlite3_step(statement) == SQLITE_DONE {
            print("insert has been successfully done")
        }
        else {
            print("sqlite step failure")
        }
        
        sqlite3_finalize(statement)
    }
    
    func deleteVoca(word: String) {
        let query = "DELETE FROM myVocaList WHERE word = '\(word)';"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete has been successfully done")
            }
            else{
                print("sqlite deletion failure")
            }
        }
        else {
            print("sqlite binding failure")
        }
        
        sqlite3_finalize(statement)
    }
    
    func readVoca() -> [String:String]{
        let query = "SELECT * FROM myVocaList"
        var statement: OpaquePointer?
        var words:[String:String] = [:]
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let word = String(cString: sqlite3_column_text(statement, 0))
                let meaning = String(cString: sqlite3_column_text(statement, 1))
                words[word] = meaning
            }
            print("select has been successfully done")
        }
        else {
            print("sqlite binding failure")
        }
        
        sqlite3_finalize(statement)
        
        return words
    }
    
    func searchVoca(word: String) -> Bool {
        let query = "SELECT * FROM myVocaList WHERE word = '\(word)';"
        var statement: OpaquePointer?
        var count = 0
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                count += 1
            }
            print("select has been successfully done \(count)")
            
            sqlite3_finalize(statement)
            
            if count == 0 {
                return false
            }
            else {
                return true
            }
        }
        else {
            print("sqlite binding failure")
            sqlite3_finalize(statement)
            return false
        }
    }
}
