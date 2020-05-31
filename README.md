## Inspiration
Everyone's staying at home and beating the pandemic curve while movies help us beat the boredom.But,as we watch more movies,we run out of movies we always wanted to watch.We always wonder if we can watch a movie that is similar to what we liked.So we thought of an idea to build an application that suggests you the movies based on how much you liked some movies.
## What it does
The application randomly gives you a set of 4 movies and asks you to rate how much you've liked them.Then,based on the ratings you gave,the app recommends you a set of movies ranked from 1 to 10 from most matched to least matched.Rank 1 means a _ must watch _ for your taste and rank 10 means _ worth a shot _ .
## How we built it
We built the application using Swift to develop the app's UI and then some file parsing.We embedded a machine learning model we trained using the movielens dataset of movies rated by various users till 2018 and little bit of Tensorflow and CreateML.The swift application takes user's inputs and feeds them to the model,the model processes the input locally and then the it gives a set of 10 movies ranked from 1 to 10.Finally,the UI displays the cards of movies which model has given.
## Challenges we ran into
We ran into a LOT of challenges.From our team of two,I knew a bit of machine learning "theoretically" but with no practical application.I learnt the whole training and testing practices while building the model.Phani learnt how to make the app UI look nice while fitting our requirements.He is new to Swift and I am new to machine learning,we both are strangers to each other's skills.The co-ordination was hard and we had to go through much troubleshooting to fix stuff at both ends.
## Accomplishments that we're proud of
We are proud of attending our first hackathon and putting what we've learnt to build a real app.We didn't even thought we would finish it.At first we thought it was a crazy idea but in the end we decided to move on and did it!
## What we learned
We learnt more than we imagined.We learnt how to use Machine learning in mobile apps,we learnt to write code for UI,we learnt to test apps before launch, and most importantly we learnt that participating in hackathons is a really nice way to learn skills!
## What's next for MovieMagic
We are thinking of expanding this idea to songs and also books.There was also an idea to include even precise ML model but the data was very very really huge that our hardware we have takes 3 days to train.We plan to include the high accuracy model and also include genre filters for the movie recommender.There's no way we are leaving this here!
