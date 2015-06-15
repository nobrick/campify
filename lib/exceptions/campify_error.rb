module Exceptions
  class CampifyError < StandardError; end
  class CampifyError::InvalidLotteryRule < CampifyError; end
end
