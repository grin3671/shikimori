module Types
  module Video
    HOSTINGS = %i[
      youtube vk ok coub rutube vimeo sibnet yandex
      streamable smotret_anime myvi youmite viuly stormo
      mediafile
    ]
    # dailymotion twitch
    KINDS = %i[
      pv
      character_trailer
      cm
      op
      ed
      op_ed_clip
      clip
      other
      episode_preview
    ]
    FORMATS = %i[default x9_16]

    Hosting = Types::Strict::Symbol
      .constructor(&:to_sym)
      .enum(*HOSTINGS)
    Kind = Types::Strict::Symbol
      .constructor(&:to_sym)
      .enum(*KINDS)

    State = Types::Strict::Symbol
      .constructor(&:to_sym)
      .enum(:uploaded, :confirmed, :deleted)
    Format = Types::Strict::Symbol
      .constructor(&:to_sym)
      .enum(*FORMATS)
  end
end
