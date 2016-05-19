_ = require('lodash')
_ = require('lodash')
flatMap = (ary, fn)-> _.flatten(_.map(ary, fn))

CanParseConflicts =
  parseConflicts: (schedules) ->
    entries = @toEntries(schedules)
    overlaps = @toOverlaps(entries)
    conflicts = @toConflicts(overlaps)


  toEntries: (schedules)->
    flatMap schedules, (s)->
      # lol loooong name lol
      entries = s.final_schedule.rendered_schedule_entries
      _.map entries, (e)->
        _.extend(_.clone(e), schedule: s)

  toOverlaps: (entries)->
    entriesByUser = _.groupBy(entries, (e)-> e.user.id)
    userEntries = _.values(entriesByUser)
    entryRuns = flatMap(userEntries, @entryRuns.bind(@))
    pairs = flatMap(entryRuns, @pairs.bind(@))
    intersectingPairs = _.filter(pairs, @isIntersecting)
    _.map(intersectingPairs, @toOverlap.bind(@))

  toConflicts: (overlaps)->
    overlapById = _.groupBy(overlaps, @overlapId)
    overlapRuns = _.values(overlapById)
    _.map(overlapRuns, @toConflict)


  toOverlap: (pair)->
    user: pair[0].user
    schedule_one: pair[0].schedule
    schedule_two: pair[1].schedule
    span: @intersection(pair[0], pair[1])

  toConflict: (overlaps)->
    spans = _.map(overlaps, (o)-> o.span)

    user: overlaps[0].user
    schedule_one: overlaps[0].schedule_one
    schedule_two: overlaps[0].schedule_two
    spans: spans


  overlapId: (o)->
    if o.schedule_one.id < o.schedule_two.id
      o.user.id + o.schedule_one.id + o.schedule_two.id
    else
      o.user.id + o.schedule_two.id + o.schedule_one.id

  entryRuns: (userEntries)->
    userEntries = _.sortBy(userEntries, (ue)-> ue.start)
    @groupInRuns userEntries, (lastGroup, entry)->
      maxEnd = _.maxBy(lastGroup, (e)-> e.end)
      entry.start < maxEnd


  intersection: (e1, e2)->
    start: _.max([e1.start, e2.start])
    end: _.min([e1.end,  e2.end])

  isIntersecting: (pair)->
    pair[0].start < pair[1].end && pair[1].start < pair[0].end

  pairs: (ary)->
    return [] if ary.length == 0
    head = ary[0]
    tail = ary.slice(1)
    headPerms = _.map(tail, (i)-> [head, i])
    headPerms.concat(@pairs(tail))

  groupInRuns: (ary, pred)->
    currentGroup = [ary[0]]
    rest = ary.slice(1)

    _.reduce(rest, ((acc, val)->
      doesBelong = pred(currentGroup, val)
      if doesBelong
        currentGroup.push(val)
      else
        currentGroup = [val]
        acc.push(currentGroup)
      acc
    ), [currentGroup])

module.exports = CanParseConflicts
