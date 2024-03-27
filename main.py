import db
import openai
import json


def get_answer(question):
    messages = [{'role': 'user', 'content': question}]
    functions = [
        {
            "name": "get_streaming_info",
            "description": """Get the number of streams(such as total, average, min, max) for a given date, movie or a 
            director. If function returns -1 then it means there is no movie streaming with respect to the provided input. 
            """,
            "parameters": {
                "type": "object",
                "properties": {
                    "date": {
                        "type": "string",
                        "description": "Date of movie is being streamed in format YYYY-MM-DD e.g 2022-04-01."
                    },
                    "movie": {
                        "type": "string",
                        "description": "name of movie being streamed."
                    },
                    "director": {
                        "type": "string",
                        "description": "name of director of the movie."
                    },
                    "operation": {
                        "type": "string",
                        "description": "if any details (date,movie,director) is provided then the operations parameter "
                                       "such as total, average, maximum, minimum will tell number of streams. ",
                        "enum": ["sum", "max", "min", "avg"]
                    }
                }
            }
        }
    ]

    response = openai.chat.completions.create(
        model='gpt-3.5-turbo',
        messages=messages,
        functions=functions,
        function_call='auto'
    )
    # print(response)
    response_message = response.choices[0].message
    # print(response_message)
    if response_message.__getattribute__("function_call"):
        available_functions = {
            "get_streaming_info": db.get_movie_info
        }
        function_name = response_message.function_call.name
        # print(function_name)
        function_to_call = available_functions[function_name]
        # print("1")
        # print(response_message.function_call.arguments)
        function_args = json.loads(response_message.function_call.arguments)
        # print("1")
        # print(function_args)
        function_response = function_to_call(function_args)
        # print(function_response)
        # print("1")

        messages.append(response_message)
        messages.append(
            {
                "role": "function",
                "name": function_name,
                "content": str(function_response)
            }
        )
        second_response = openai.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=messages
        )

        return second_response.choices[0].message.content

    else:
        return response_message.content

    # print(response_message)


if __name__ == '__main__':
    # print(get_answer("What are the maximum number of streaming on 2022-04-02 ?"))
    # print(get_answer("What are the number of streaming of movies directed by Coen brothers?"))
    # print(get_answer("tell me number of streaming for each date present in database"))#wrong output
    print(get_answer("Tell me the name of all directors present in database"))
