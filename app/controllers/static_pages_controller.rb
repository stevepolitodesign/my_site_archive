class StaticPagesController < ApplicationController
    def home
        set_meta_tags  description: "My Site Archive captures screenshots, downloads source code, and monitors DNS records helping you keep track of changes on your websites without needing to restore from a backup. Think of it like the Wayback Machine on steroids."
    end

    def pricing
    end

    def faqs
    end

    def features
        set_meta_tags  description: "My Site Archive captures screenshots, downloads source code, and monitors DNS records helping you keep track of changes on your websites without needing to restore from a backup. Think of it like the Wayback Machine on steroids."
    end

    def terms_of_use
    end

    def privacy_policy
    end
end
