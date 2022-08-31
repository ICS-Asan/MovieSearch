import Foundation

struct BoxOfficeMovieDTO: Codable {
    let rank: String
    let rankInten: String
    let rankOldAndNew: RankOldAndNew
    let movieNm: String
    let openDt: String
    let audiCnt: String
    let audiAcc: String
    
    func toDomain() -> BoxOfficeMovie? {
        guard let rank = Int(rank),
              let rankInten = Int(rankInten),
              let audiCnt = Int(audiCnt),
              let audiAcc = Int(audiAcc) else { return nil }
        
        return BoxOfficeMovie(
            rank: rank,
            changedRankValue: rankInten,
            isNew: rankOldAndNew.isNew,
            title: movieNm,
            openDate: openDt,
            dailyAudience: audiCnt,
            totalAudience: audiAcc
        )
    }
}

enum RankOldAndNew: String, Codable {
    case new = "NEW"
    case old = "OLD"
    
    var isNew: Bool {
        switch self {
        case .new:
            return true
        case .old:
            return false
        }
    }
}
