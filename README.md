# Pi Garbage Schedule

Garbage schedule indicators for raspberry pi. Also for weather.

![Cardboard cover for LEDs](https://pbs.twimg.com/media/DILak1TW0AApdLA.jpg)

This is a work in progress and should currently neither be used nor read by anybody.

## The garbage problem

If there's only one garbage can allocated for many people the garbage can might be full when you want to take out the trash.

## The solution

 The obvious solution is to connect indicator LEDs to your Raspberry Pi which tell you which trash can is probably not full right now (simply by knowing the garbage disposal schedule; if the trash can was emptied in the last days there's probably room left).

## The ethical dilemma

Given that the garbage can capacity is a finite resource taking advantage of the garbage disposal schedule like this means that everyone else will have a higher probability of encounterig a full garbage can. On the other hand, everyone has access to the schedule. Whether using the schedule like this is ethical or not is left as an exercise for the reader. Discuss this with @RedNifre on Twitter!

## Tragedy of the commons

If too many people who share the same trash can participate in this arms race nobody will win: The garbage end game is everyone dropping their garbage right after the trash can was emptied.

## Future of this project

1. add indicators for weather (to answer the "should I bring an umbrella?" question).
2. move the gpio part to a separate gem and add a config.
3. move weather indicator to separate repo and make it configurable.
4. Figure out how to get garbage schedule data live (instead of hardcoding it).
