# Diners, Drive-Ins, and Drives

Here's a script for scraping Food Network's Diners, Drive-Ins, and Dives restaurant listing. As an accidental founding member of [Team Fieri](https://www.thewrap.com/team-guy-fieri-comes-defense-skewers-ny-times-food-critic-65491/), I figured, "Why not?" 

There's two scripts here. Run `triple_d_scraper.rb` to grab all the restaurants and output them to a JSON file. Run `triple_d_loader.rb` to load that JSON file, geocode it, and slam it into a SQLite database.

### Requirements

To run the scraper, make sure you have Nokogiri installed: `gem install nokogiri`.

To run the loader, be sure to have SQLite3 installed. Then run: `gem install sequel geocoder`.

### Running It

There's no shebang here. There's no command line arguments. Everything is hardwired. So:

- To scrape: `ruby triple_d_scraper.rb`
- To load: `ruby triple_d_loader.rb`

Bon appetit!