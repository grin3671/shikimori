class Abilities::VideoModerator
  include CanCan::Ability
  prepend Draper::CanCanCan

  def initialize user
    can :manage, AnimeVideoReport
    can %i[new create edit update], AnimeVideo do |anime_video|
      !user.banned? && !anime_video.banned? && !anime_video.copyrighted?
    end
    can :manage, Version do |version|
      version.item_type == AnimeVideo.name
    end

    if user.id == User::BAKSIII_ID
      can %i[index show none edit update], AnimeVideoAuthor
    end
  end
end
