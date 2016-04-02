get_start_date = (command) ->
  startDate = Date.today()

  if command == "lastyear"
      startDate = startDate.removeDays(365)
  else if command == "lastmonth"
      startDate = startDate.removeDays(30)
  else if command == "lastweek"
      startDate = startDate.removeDays(7)
  else if command == "thisyear"
      startDate.setMonth(0)
      startDate.setDate(1)
  else if command == "thismonth"
      startDate.setDate(1)
  else if command == "yesterday"
      startDate = Date.yesterday()

  return startDate.toYMD("-")



get_end_date = (command) ->
  endDate = Date.today()

  if command == "thisyear"
      endDate.setMonth(11)
      endDate.setDate(1)
  else if command == "yesterday"
      endDate = Date.yesterday()

  return endDate.toYMD("-")


module.exports = {
  get_start_date: get_start_date,
  get_end_date: get_end_date
}
