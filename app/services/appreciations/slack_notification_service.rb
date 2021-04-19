class Appreciations::SlackNotificationService < Service
  def perform(appreciation)
    @appreciation = appreciation
    blocks = build_blocks

    log(JSON.pretty_generate(blocks))

    ScrapStats.slack_notifier.post blocks: blocks
  end

private

  def build_blocks
    blocks = []

    # Title
    block_title = {
      type: "section",
      text: {
        type: "mrkdwn",
        text: "A new Appreciation by *#{@appreciation.by.name}* to *#{@appreciation.to_formatted}*:"
      }
    }

    # Message
    block_message = {
      type: "section",
      text: {
        type: "plain_text",
        text: @appreciation.message
      }
    }

    # I can not make it work with Rails blog URLs
    if Rails.env.test? && @appreciation.pic.attached?
      block_message[:accessory] = {
        type: "image",
        image_url: @appreciation.pic_url,
        alt_text: "Appreciation Header"
      }
    end

    # Link
    block_link = {
      type: "section",
      fields: [
        {
          type: "mrkdwn",
          text: "<https://#{APP_CONFIG[:hosts].first}/front/appreciations/#{@appreciation.uuid}|Check it here>"
        }
      ]
    }

    blocks = []
    blocks << block_title
    blocks << block_message
    blocks << block_link

    blocks
  end

  def log(message)
    return if !APP_CONFIG[:slack_notifier]["debug"]
    Rails.logger.debug("[SlackNotificationService] #{message}")
  end
end
