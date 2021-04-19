require "test_helper"

class Appreciations::SlackNotificationServiceTest < ActiveSupport::TestCase
  def test_perform
    appreciable_user = FactoryBot.create(:appreciable_user, name: "Wendell Jaskolski")
    appreciable_user_to_1 = FactoryBot.create(:appreciable_user, name: "Chet Beahan")
    appreciable_user_to_2 = FactoryBot.create(:appreciable_user, name: "Dot Yost")

    appreciation = FactoryBot.create(:appreciation, uuid: "APPRECIATION_UUID", by: appreciable_user, to: [appreciable_user_to_1, appreciable_user_to_2], message: "MESSAGE LONGER THAN 20 CHARS")

    expected_blocks = [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "A new Appreciation by *Wendell Jaskolski* to *Chet Beahan and Dot Yost*:"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "plain_text",
          "text": "MESSAGE LONGER THAN 20 CHARS"
        },
        "accessory": {
          "type": "image",
          "image_url": "PIC_URL",
          "alt_text": "Appreciation Header"
        }
      },
      {
        "type": "section",
        "fields": [
          {
            "type": "mrkdwn",
            "text": "<https://railsskeleton.scrapstats.com.test/front/appreciations/APPRECIATION_UUID|Check it here>"
          }
        ]
      }
    ]

    appreciation.expects(:pic_url).returns("PIC_URL")
    Slack::Notifier.any_instance.expects(:post).with(blocks: expected_blocks)

    Appreciations::SlackNotificationService.perform(appreciation)
  end
end
