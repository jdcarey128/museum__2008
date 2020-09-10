class Museum
  attr_reader :name,
              :exhibits,
              :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
  end

  def recommend_exhibits(patron)
    @exhibits.select do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def patron_exhibit_interests
    patron_exhibit_interests = {}
    @patrons.each do |patron|
      recommend_exhibits(patron).each do |exhibit|
        if patron_exhibit_interests[exhibit]
          patron_exhibit_interests[exhibit] << patron
        else
          patron_exhibit_interests[exhibit] = [patron]
        end
      end
    end
    patron_exhibit_interests
  end

  def patrons_by_exhibit_interest
    new_patron_exhibit_interests = patron_exhibit_interests
    exhibit_interests = patron_exhibit_interests.keys
    @exhibits.each do |exhibit|
      if !exhibit_interests.include?(exhibit)
        new_patron_exhibit_interests[exhibit] = []
      end
    end
    new_patron_exhibit_interests
  end

end
