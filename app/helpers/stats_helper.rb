module StatsHelper
    def performance_badge(score)
        case score
        when 0...49
            "badge bg-danger"
        when 50...89
            "badge bg-warning"
        else
            "badge bg-success"
        end
    end
end
