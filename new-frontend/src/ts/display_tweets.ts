
export class Display {
    tweet_div_id = 'tweets';
    display_div_id = 'content';
    first_insert = true;

    public add_tweet(tweet:string) {
        if (this.first_insert) {
            this.show_text();
        }
        this.insert_tweet(tweet)
    }

    private show_text() {
        let display_div = this.get_id(this.display_div_id);
        display_div.style.visibility = 'visible';
        this.first_insert = false;
    }

    private insert_tweet(tweet:string) {
        let tweet_div = this.get_id(this.tweet_div_id);
        tweet_div.appendChild(tweet)
    }

    private get_id(id:string): Node {
        return document.getElementById(id)
    }
}
