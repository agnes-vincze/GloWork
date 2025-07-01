class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :mood_bar_methods

  include ApplicationHelper

  before_action :set_welcome_modal_flag

  DEFAULT_COLOR_COMPANY = '#FFEC1C'


  def set_welcome_modal_flag
    @show_mood_modal = flash[:show_mood_modal].present?
  end

  def after_sign_in_path_for(resource)
    flash[:show_mood_modal] = true
    return new_moodtracker_path
  end

  def user_percentage(moods, user)
    user_moods = moods.where(user_id: user.id)
    calculate_percentages(user_moods)
  end


def mood_bar_methods
  return unless user_signed_in?

  @range = "last week"
  @moodtrackers = filtered_moodtrackers(@range)

  percentages = calculate_percentages(@moodtrackers) || {}
  emojis = percentages[:emojis] || []

  # fallback default color (use a hex code or define a constant)
  default_color = '#FFEC1C'
  default_emoji = '😐'

  @color_company = emojis.dig(0, 2) || default_color
  @emoji_company = emojis.dig(0, 1) || default_emoji # fallback emoji, adjust as needed

  team_percents = team_percentage(@moodtrackers) || {}
  team_emojis = team_percents[:emojis] || []

  @color_team = team_emojis.dig(0, 2) || default_color
  @emoji_team = team_emojis.dig(0, 1) || default_emoji

  @user_trends = mood_trends(Moodtracker.where(user: current_user), params[:range] || @range)
end


  # def mood_bar_methods
  #   if user_signed_in?
  #     @range = "last week"
  #     @moodtrackers = filtered_moodtrackers(@range)
  #     # @color_company = calculate_percentages(@moodtrackers)[:emojis][0][2]
  #     @color_company = calculate_percentages(@moodtrackers)&.dig(:emojis, 0, 2) || 'default_color'
  #     @emoji_company = calculate_percentages(@moodtrackers)[:emojis][0][1]
  #     @color_team = team_percentage(@moodtrackers)[:emojis][0][2]
  #     @emoji_team = team_percentage(@moodtrackers)[:emojis][0][1]

  #     @user_trends = mood_trends(Moodtracker.where(user: current_user), params[:range] || "last week")
  #   end
  # end

  def filtered_moodtrackers_by(moods, range, previous: false)
    case range
    when "last 6 months"
      from = previous ? 1.year.ago : 6.months.ago
      to = previous ? 6.months.ago : Time.current
    when "last month"
      from = previous ? 2.months.ago : 1.month.ago
      to = previous ? 1.month.ago : Time.current
    when "last week"
      from = previous ? 14.days.ago : 7.days.ago
      to = previous ? 7.days.ago : Time.current
    else
      return moods
    end

    moods.where(date: from..to)
  end

  def mood_trends(moods, range)
    current_scope = filtered_moodtrackers_by(moods, range)
    previous_scope = filtered_moodtrackers_by(moods, range, previous: true)

    current_stats = calculate_percentages(current_scope)
    previous_stats = calculate_percentages(previous_scope)

    trends = {}

    [:happy, :neutral, :sad].each do |mood|
      change = current_stats[mood] - previous_stats[mood]
      trends[mood] = mood_trend_text(mood, change)

    end

    trends
  end

  def team_percentage(moods)
    team_users = User.where(team: current_user.team)
    team_moods = moods.where(user: team_users)
    calculate_percentages(team_moods)
  end

  def filtered_moodtrackers(range)
    case range
    when "last 6 months"
      Moodtracker.where("date >= ?", 6.months.ago)
    when "last month"
      Moodtracker.where("date >= ?", 1.month.ago)
    when "last week"
      Moodtracker.where("date >= ?", 7.days.ago)
    else
      Moodtracker.all
    end
  end

  def calculate_percentages(moods)
    sad = 0
    neutral = 0
    happy = 0

    moods.each do |mood|
      case mood.mood
      when 1 then sad += 1
      when 2 then neutral += 1
      when 3 then happy += 1
      end
    end

    total = sad + neutral + happy
    return { happy: 0, neutral: 0, sad: 0, emojis: [] } if total == 0

    p_happy = (happy.to_f / total * 100).round
    p_neutral = (neutral.to_f / total * 100).round
    p_sad = (sad.to_f / total * 100).round

    {
      happy: p_happy,
      neutral: p_neutral,
      sad: p_sad,
      emojis: emoji_percentage(p_happy, p_sad, p_neutral)
    }
  end

  def emoji_percentage(happy, sad, neutral)
    [[happy, "😀", "#93F271"], [neutral, "😐", "#FFEC1C"], [sad, "☹️", "#FF7272"]].sort_by { |a| a[0] }.reverse
  end

end
