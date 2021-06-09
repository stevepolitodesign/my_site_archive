class StaticPagesController < ApplicationController
    include Schemable
    layout "landing", only: [:home, :features]

    before_action do |controller|
        set_schema_dot_org(
            schema: {
                :name => "My Site Archive",
                :offers =>{
                    :@type => "Offer",
                    :price => "2.00",
                    :priceCurrency => "USD"
                }
            }
        )
    end 

    def home
        set_meta_tags(
            description: "My Site Archive captures screenshots, downloads source code, tracks Google Lighthouse scores and monitors DNS records helping you keep track of changes on your websites without needing to restore from a backup. Think of it like the Wayback Machine on steroids. Sign up today for a 30 day free trial. No credit card required.",
            og: {
                image: "https://mugshotbot.com/m/HBQnrzXu",
            },
            twitter: {
                card: "summary_large_image",
            }
        )
    end

    def pricing
    end

    def faqs
    end

    def contact
    end    

    def features
        set_meta_tags  description: "My Site Archive captures screenshots, downloads source code, tracks Google Lighthouse scores and monitors DNS records helping you keep track of changes on your websites without needing to restore from a backup. Think of it like the Wayback Machine on steroids. Sign up today for a 30 day free trial. No credit card required."
    end

    def terms_of_use
    end

    def privacy_policy
    end
end
