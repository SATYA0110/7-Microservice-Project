# Stage 1: Build the C# application
FROM ://microsoft.com AS build
WORKDIR /source

# Copy csproj and restore dependencies
COPY payment-service.csproj .
RUN dotnet restore

# Copy the remaining source code and publish
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

# Stage 2: Build the production runtime image
FROM ://microsoft.com
WORKDIR /app
COPY --from=build /app .

# Configure a secure non-root user
RUN addgroup -g 10007 paymentuser && adduser -u 10007 -G paymentuser -D -S paymentuser
RUN chown -R paymentuser:paymentuser /app
USER paymentuser

# Match the explicit port defined in the C# Program.cs file (8085)
EXPOSE 8085

CMD ["dotnet", "payment-service.dll"]
