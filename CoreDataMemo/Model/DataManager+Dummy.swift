//
//  DataManager+Dummy.swift
//  CoreDataMemo
//
//  Created by Ko Minhyuk on 5/28/25.
//

import Foundation
import CoreData

// Dummy Data > 테스트용 데이터
// Batch > 여러 데이터/작업을 묶음으로 한 번에 처리
// Insert

extension DataManager {
    func insertDummyData() {
#if DEBUG
        guard let path = Bundle.main.path(forResource: "lipsum", ofType: "txt") else {
            fatalError("경로를 가져오지 못함")
        }

        do {
            let countRequest = MEMOEntity.fetchRequest()

            let count = try mainContext.count(for: countRequest)
            //let count = try mainContext.fetch(countRequest).count
            if count > 0 {
                return
            }


            let source = try String(contentsOfFile: path, encoding: .utf8)

            let sentences = source
                .components(separatedBy: .newlines) // 라인을 기준으로 분리
                .filter { $0.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 } // 내용을 가진 줄만 필터링

            var dataList = [[String: Any]]()

            for sentence in sentences {
                // 일반적인 Insert
//                let memo = MemoEntity(context: mainContext) // 1. 새로운 엔티티 만들기
//                memo.content = sentence // 2
//                memo.insertDate = Date(timeIntervalSinceNow: Double.random(in: 0 ... 3600 * 24 * 30) * -1) // 3

                // Batch Insert
                dataList.append([
                        "content": sentence,
                        "insertDate": Date(timeIntervalSinceNow: Double.random(in: 0 ... 3600 * 24 * 30) * -1)
                    ])
            }

            let insertRequest = NSBatchInsertRequest(entityName: "Memo", objects: dataList)

            if let result = try mainContext.execute(insertRequest) as? NSBatchInsertResult, let succeeded = result.result as? Bool {
                if succeeded {
                    print("Batch Insert 성공")
                } else {
                    print("Batch Insert 실패")
                }
            }
        } catch {
            print(error)
        }
#endif
    }
}
