module StatsHelper
    def performance_badge(score)
        case score
        when 0...49
            "d-flex justify-content-center align-items-center rounded-circle border border-2 border-danger"
        when 50...89
            "d-flex justify-content-center align-items-center rounded-circle border border-2 border-warning"
        else
            "d-flex justify-content-center align-items-center rounded-circle border border-2 border-success"
        end
    end
end
