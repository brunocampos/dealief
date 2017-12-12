# Dealief

When i was trying to come up with a original name for the app, considering the challenge and the company goals, i started idealizing the concept of user relieved by having an app taking care of his contracts. With that in mind i tried playing with a few words and got to the final name, __Dealief__, a mashup of _deals_ and _relief_.

## Challenge - The contract management API

Managing contracts is a time-consuming task. They all have different terms, renewable periods, termination windows and different ways to be terminated. Now imagine handling millions of contracts: that’s what  volders  does.

This code challenge is about creating a simplified version of our contract management API, enabling clients to create and update their contract details.

## Instructions Notes

I implemented this challenge in __Elixir__ with the help of __Phoenix framework__.

To start Phoenix server:

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.create && mix ecto.migrate`
* Start Phoenix endpoint with `mix phx.server`

Now we can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Implementation Notes

Using the user stories described on the coding challenge as the base for my work, i did some changes, that even though aren't considerable of turning it in a production-ready app, try to manage a middle-ground between the simplest MVP from the challenge requisites with some extras that elaborate just a bit more the final example.

I opted to use the built-in features Elixir and Phoenix provides us as much as possible. We can notice that for example, in the authentication process, where i used the Phoenix.Token for generating and verifying the user token.

The provided user stories mentioned 2 resources, __Users__ and __Contracts__ where the later would have a associated _user_ and a _Vendor_ name. I expanded this process into 3 Resources, with __Vendor__ having its own endpoint. These 3 resources are separated into 2 Domain boundaries, using the new contexts feature introduced in Phoenix 1.3.

The __Account__ context contains the __User__ schema and the public interface to access functions directly related to Users.  
The __Agreement__ context contains the __Vendor__ and the __Contract__ schemas and the public interfaces to handle those resources. Given __Contract__ schema has associations with both __Vendor__ and __User__ i introduced, especially in the case of the relation between users and contracts, some specific functions to handle both, and expose just the right content, avoiding leaking unauthorized data to all users.

The API is separated between a set of public and private routes, where, being this an exercise, i added some compromises on the public routes to help testing the app. This is noticeable for example, in the _index_ and _show_ actions of __UserController__, which are set in the public api pipeline to make it easier to check and test different users.

For the private routes i added a custom __Plug__ named, __ApiAuthorizeUser__ that verifies the user token passed in the header. Please notice the plug will check for _Authorization_ header with "Bearer token". The tokens expire after 1 day.

Other custom feature i introduced in this app was a custom Ecto.Type, named __ContractDate__. The main reason for this implementation came, first, from a series of errors regarding the microsecond precision that i was experiencing while testing the *starts_on* and *ends_on* fields as naive_datetime, where afer posting the issue on [Elixir Forum](https://elixirforum.com/t/custom-fields-with-naive-datetime-type-report-difference-in-microseconds-on-tests/10541) i came to conclusion that those things were already being addressed to be easier to deal in next versions of _Elixir_ and _Ecto_. The second reason was because i wanted to explore a bit more the notion of custom Ecto.Type and use that so that the app would be able to insert both the *starts_on* and *ends_on* contract dates with a string using the more tradicional European format of DD-MM-YYYY.

Regarding tests, i used just __ExUnit__ for this exercise, without any libraries to handle factories or implement feature tests. I do know that there's some code duplication on them, but considering the timeframe, i set the main goal to make them unit test the public functions provided by the _Agreement_ and _Account_ contexts and also the controllers.

## Summary

The final code from this exercise provides just a very simple starting point for an app that would handle users contracts and, even breaks some rules regarding accessing its content, but as i mentioned before, that was made on purpose to help evaluating it.

A more fully-featured app would have to use a much bigger data model, since for example, the Vendor is directly connected to a Contract, but in real world a Vendor, would have at least a set of deal options to select and add then on the contract. The users would require a more robust form of access control, and different roles most likely, but i hope i managed to find a good balance of features for the challenge.