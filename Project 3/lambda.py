def my_handler(event, context):
    #message = 'Hello {} {}!'.format(event['first_name'],
    #                                event['last_name'])
    return {
        "Event is " + str(event) + " and context is " + str(context)
    }
