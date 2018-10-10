def my_handler(event, context):
    #message = 'Hello {} {}!'.format(event['first_name'],
    #                                event['last_name'])

    endstr = "messsage is " + event + " and context is " + context
    return endstr
